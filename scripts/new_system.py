#!/usr/bin/env python3
"""Scaffold a new enterprise system, correct by construction.

Prompts only for what cannot be inferred, offers the controlled vocabularies as
numbered choices so invalid values are impossible to enter, and writes every
file the pipeline expects — including registering the system in the canonical
manifest, which is the step contributors most often forget.

    make new-system                 # interactive
    make new-system NAME=TEES       # skips the first prompt

Non-interactive callers (the CSV importer) use scaffold() directly.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

from dsl_model import ROOT

SYSTEMS_DIR = ROOT / "models/enterprise/systems"
MANIFEST = ROOT / "models/model.dsl"
VOCABULARY = json.loads((ROOT / "models/shared/vocabulary.json").read_text())


def identifier_for(name: str) -> str:
    """TEES -> tees;  Asset Hub -> assetHub."""
    parts = re.split(r"[\s_-]+", name.strip())
    if len(parts) == 1 and parts[0].isupper():
        return parts[0].lower()
    head, *rest = parts
    return head[0].lower() + head[1:] + "".join(p[:1].upper() + p[1:] for p in rest)


def choose(label: str, options: list[str]) -> str:
    print(f"\n{label}")
    for i, option in enumerate(options, 1):
        print(f"  {i}. {option}")
    while True:
        raw = input(f"  choice [1-{len(options)}]: ").strip()
        if raw.isdigit() and 1 <= int(raw) <= len(options):
            return options[int(raw) - 1]
        print("  not a valid choice")


def ask(label: str, *, required: bool = True, default: str = "") -> str:
    suffix = f" [{default}]" if default else ""
    while True:
        value = input(f"{label}{suffix}: ").strip() or default
        if value or not required:
            return value
        print("  required")


def capabilities() -> list[str]:
    """Capabilities that have a documentation page — the validator requires one."""
    return sorted(
        p.stem.replace("-", " ").title().replace(" And ", " & ")
        for p in (ROOT / "docs/capabilities").glob("*.adoc")
    )


def scaffold(name: str, category: str, properties: dict[str, str],
             tags: list[str] | None = None, *, quiet: bool = False) -> Path:
    """Write the system's files and register it in the manifest."""
    identifier = identifier_for(name)
    folder = SYSTEMS_DIR / name.replace(" ", "")
    if folder.exists():
        raise SystemExit(f"{folder.relative_to(ROOT)} already exists")
    (folder / "docs").mkdir(parents=True)

    tag_list = " ".join(f'"{t}"' for t in ["EnterpriseSystem", category] + (tags or []))
    property_lines = "\n".join(
        f'            {k} "{v}"' for k, v in properties.items() if v
    )

    (folder / "system.dsl").write_text(f'''group "{category}" {{
    {identifier} = softwareSystem "{name}" {{
        description "{properties.pop('description', 'TODO: one-sentence description.')}"

        tags {tag_list}

        properties {{
{property_lines}
        }}

        !docs docs
    }}
}}
''')

    (folder / "docs" / "01-overview.adoc").write_text(f'''== {name}

TODO: what this system does, and why it exists.

=== Responsibilities

* TODO

=== Key Facts

[cols="1,2"]
|===
| Owner | {properties.get('owner', 'TODO')}
| Capability | {properties.get('capability', 'TODO')}
| Portfolio Category | {category}
| Lifecycle | {properties.get('lifecycle', 'TODO')}
| Criticality | {properties.get('criticality', 'TODO')}
|===
''')

    # Register in the manifest, in the systems block, alphabetically.
    lines = MANIFEST.read_text().splitlines()
    entry = f"!include enterprise/systems/{folder.name}/system.dsl"
    if entry not in lines:
        system_lines = [i for i, l in enumerate(lines)
                        if l.startswith("!include enterprise/systems/")]
        insert_at = next(
            (i for i in system_lines if lines[i] > entry), system_lines[-1] + 1
        )
        lines.insert(insert_at, entry)
        MANIFEST.write_text("\n".join(lines) + "\n")

    if not quiet:
        print(f"""
Created:
  {(folder / 'system.dsl').relative_to(ROOT)}
  {(folder / 'docs/01-overview.adoc').relative_to(ROOT)}
  registered in {MANIFEST.relative_to(ROOT)}

The standard context view is generated automatically — run `make views`.
Next: fill in the TODOs, then `make validate`.""")
    return folder


def main() -> int:
    name = sys.argv[1] if len(sys.argv) > 1 else ""
    print("New enterprise system\n" + "─" * 21)
    if not name:
        name = ask("System name (as it is known, e.g. TEES)")

    category = choose("Portfolio category:", VOCABULARY["portfolioCategories"])
    capability_options = capabilities()
    properties = {
        "description": ask("One-sentence description", required=False),
        "owner": ask("Owning team"),
        "capability": choose("Business capability:", capability_options),
        "lifecycle": choose("Lifecycle:", VOCABULARY["properties"]["lifecycle"]),
        "criticality": choose("Criticality:", VOCABULARY["properties"]["criticality"]),
        "hosting": choose("Hosting:", VOCABULARY["properties"]["hosting"]),
        "runtime": ask("Runtime (optional, e.g. .NET 10)", required=False),
        "database": ask("Database (optional)", required=False),
        "supportTeam": ask("Support team (optional)", required=False),
    }
    scaffold(name, category, properties)
    return 0


if __name__ == "__main__":
    sys.exit(main())
