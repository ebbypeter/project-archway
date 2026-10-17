"""Software bills of materials (SBOMs) stored with each system and solution.

Convention (see docs/architecture-as-code/sbom.md):

  <asset folder>/sbom/<elementIdentifier>.cdx.json

where the asset folder is a system's (models/enterprise/systems/<Name>/) or a
solution's (models/solutions/<Name>/), and the file is named after the model
element it describes — the software system itself, or one of its containers
when the system ships several deployables. Files are CycloneDX JSON.

A system with no SBOM states why in its `sbom` property (for example a SaaS
product whose vendor does not publish one); otherwise it is reported missing.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from datetime import date, datetime
from pathlib import Path

from dsl_model import MODELS_DIR, Model

ASSET_ROOTS = [MODELS_DIR / "enterprise" / "systems", MODELS_DIR / "solutions"]
SUFFIX = ".cdx.json"

# An SBOM older than this is reported as stale: it no longer describes what
# is running once a few releases have gone out.
MAX_AGE_DAYS = 90


@dataclass
class Component:
    name: str
    group: str         # e.g. a Maven groupId; "" where the ecosystem has none
    version: str
    licence: str
    ecosystem: str     # purl type: maven, nuget, npm, ...


@dataclass
class Sbom:
    path: Path
    system: str        # identifier of the owning software system
    element: str       # identifier the file is named after
    produced: date | None = None
    tool: str = ""
    components: list[Component] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)

    @property
    def age_days(self) -> int | None:
        return (date.today() - self.produced).days if self.produced else None

    @property
    def stale(self) -> bool:
        return self.age_days is not None and self.age_days > MAX_AGE_DAYS


def asset_folder(path: Path) -> Path | None:
    """The system or solution folder a file belongs to, if any."""
    for root in ASSET_ROOTS:
        try:
            relative = path.relative_to(root)
        except ValueError:
            continue
        return root / relative.parts[0]
    return None


def _licence(entry: dict) -> str:
    licences = []
    for item in entry.get("licenses") or []:
        if "expression" in item:
            licences.append(item["expression"])
        else:
            licence = item.get("license") or {}
            licences.append(licence.get("id") or licence.get("name") or "")
    return " AND ".join(l for l in licences if l) or "-"


def _tool(metadata: dict) -> str:
    tools = metadata.get("tools") or []
    # CycloneDX 1.5+ nests tools under "components"; 1.4 and earlier use a list.
    if isinstance(tools, dict):
        tools = tools.get("components") or []
    return ", ".join(
        f"{t.get('name', '')} {t.get('version', '')}".strip() for t in tools
    )


def _parse(sbom: Sbom) -> None:
    try:
        doc = json.loads(sbom.path.read_text())
    except (OSError, ValueError) as error:
        sbom.errors.append(f"not valid JSON ({error})")
        return
    if not isinstance(doc, dict) or doc.get("bomFormat") != "CycloneDX":
        sbom.errors.append('not a CycloneDX SBOM (bomFormat must be "CycloneDX")')
        return
    if not doc.get("specVersion"):
        sbom.errors.append("missing specVersion")

    metadata = doc.get("metadata") or {}
    stamp = metadata.get("timestamp")
    if stamp:
        try:
            sbom.produced = datetime.fromisoformat(stamp.replace("Z", "+00:00")).date()
        except ValueError:
            sbom.errors.append(f"metadata.timestamp '{stamp}' is not an ISO 8601 date")
    else:
        sbom.errors.append("missing metadata.timestamp — when was it produced?")
    sbom.tool = _tool(metadata)

    components = doc.get("components", [])
    if not isinstance(components, list):
        sbom.errors.append("components must be a list")
        return
    for entry in components:
        if not isinstance(entry, dict) or not entry.get("name"):
            sbom.errors.append("a component has no name")
            continue
        purl = entry.get("purl", "")
        sbom.components.append(Component(
            name=entry["name"],
            group=entry.get("group") or "",
            version=entry.get("version", "-"),
            licence=_licence(entry),
            ecosystem=purl[4:].split("/", 1)[0] if purl.startswith("pkg:") else "-",
        ))


def load(model: Model) -> list[Sbom]:
    """Every SBOM file in the repository, parsed and matched to the model.

    Problems (unreadable file, unknown element, file outside a system or
    solution folder) are recorded on each Sbom's `errors`, not raised.
    """
    folder_system = {}
    for system in model.systems:
        folder = asset_folder(system.file)
        if folder:
            folder_system[folder] = system.identifier

    sboms = []
    for path in sorted(MODELS_DIR.rglob(f"sbom/*{SUFFIX}")):
        folder = asset_folder(path)
        system = folder_system.get(folder) if folder else None
        sbom = Sbom(path=path, system=system or "", element=path.name[: -len(SUFFIX)])
        if path.parent != (folder / "sbom" if folder else None):
            sbom.errors.append(
                "SBOMs belong in the sbom/ folder directly under a system or "
                "solution folder"
            )
        elif not system:
            sbom.errors.append("this folder defines no software system")
        elif (sbom.element != system
              and model.parents.get(sbom.element) != system):
            sbom.errors.append(
                f"file name must be the identifier of '{system}' or one of its "
                f"containers, not '{sbom.element}'"
            )
        _parse(sbom)
        sboms.append(sbom)
    return sboms


def element_name(model: Model, identifier: str) -> str:
    for system in model.systems:
        if system.identifier == identifier:
            return system.name
    return model.containers.get(identifier, identifier)
