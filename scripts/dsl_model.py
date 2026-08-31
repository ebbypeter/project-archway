"""Minimal parser for this repository's Structurizr DSL conventions.

This is NOT a general Structurizr DSL parser. It relies on the conventions
enforced in this repository (one element definition per line, properties one
per line, relationship on one line). structurizr-cli remains the authoritative
compiler; this parser only powers the convention checks and inventory reports.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODELS_DIR = ROOT / "models"

SYSTEM_RE = re.compile(r'^\s*(\w+)\s*=\s*softwareSystem\s+"([^"]+)"', re.M)
PERSON_RE = re.compile(r'^\s*(\w+)\s*=\s*person\s+"([^"]+)"(?:\s+"([^"]*)")?', re.M)
CONTAINER_RE = re.compile(r'^\s*(\w+)\s*=\s*container\s+"([^"]+)"(?:\s+"([^"]*)")?(?:\s+"([^"]*)")?', re.M)
REL_RE = re.compile(r'^\s*(\w+)\s*->\s*(\w+)(?:\s+"([^"]*)")?(?:\s+"([^"]*)")?', re.M)
TAGS_RE = re.compile(r'^\s*tags\s+(.+)$', re.M)
PROP_RE = re.compile(r'^\s*(\w+)\s+"([^"]*)"\s*$', re.M)
INCLUDE_RE = re.compile(r'^\s*!include\s+(\S+)', re.M)


@dataclass
class SoftwareSystem:
    identifier: str
    name: str
    file: Path
    tags: list[str] = field(default_factory=list)
    properties: dict[str, str] = field(default_factory=dict)


@dataclass
class Relationship:
    source: str
    destination: str
    description: str
    technology: str
    file: Path


@dataclass
class Model:
    systems: list[SoftwareSystem] = field(default_factory=list)
    people: dict[str, str] = field(default_factory=dict)      # identifier -> name
    containers: dict[str, str] = field(default_factory=dict)  # identifier -> name
    relationships: list[Relationship] = field(default_factory=list)
    person_files: dict[str, Path] = field(default_factory=dict)
    container_files: dict[str, Path] = field(default_factory=dict)


def _block_body(text: str, open_brace_index: int) -> str:
    """Return the text between a '{' and its matching '}'."""
    depth = 0
    for i in range(open_brace_index, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[open_brace_index + 1:i]
    return text[open_brace_index + 1:]


def _strip_comments(text: str) -> str:
    lines = []
    for line in text.splitlines():
        stripped = line.lstrip()
        if stripped.startswith("#") or stripped.startswith("//"):
            continue
        lines.append(line)
    return "\n".join(lines)


def model_dsl_files() -> list[Path]:
    """All model fragment files.

    Excludes the manifest itself, shared styles, and view fragments
    (views.dsl / views/ directories) — views are defined next to the elements
    they show but are included by the workspace views block, not the model.
    """
    files = []
    for path in sorted(MODELS_DIR.rglob("*.dsl")):
        rel = path.relative_to(MODELS_DIR)
        if rel == Path("model.dsl") or rel.parts[0] == "shared":
            continue
        if path.name == "views.dsl" or "views" in rel.parts[:-1]:
            continue
        files.append(path)
    return files


def manifest_includes() -> list[Path]:
    """Every file reachable from the canonical manifest, following nested
    !include directives (e.g. components.dsl included from containers.dsl)."""
    seen: list[Path] = []

    def walk(file: Path) -> None:
        text = _strip_comments(file.read_text())
        for inc in INCLUDE_RE.findall(text):
            target = (file.parent / inc).resolve()
            if target.is_file() and target not in seen:
                seen.append(target)
                walk(target)

    walk(MODELS_DIR / "model.dsl")
    return seen


def parse_model() -> Model:
    model = Model()
    for path in model_dsl_files():
        text = _strip_comments(path.read_text())

        for match in SYSTEM_RE.finditer(text):
            identifier, name = match.group(1), match.group(2)
            brace = text.find("{", match.end())
            body = _block_body(text, brace) if brace != -1 else ""

            tags: list[str] = []
            for tag_line in TAGS_RE.findall(body):
                tags.extend(re.findall(r'"([^"]+)"', tag_line))

            properties: dict[str, str] = {}
            prop_match = re.search(r'properties\s*\{([^}]*)\}', body)
            if prop_match:
                properties = dict(PROP_RE.findall(prop_match.group(1)))

            model.systems.append(SoftwareSystem(identifier, name, path, tags, properties))

            for cmatch in CONTAINER_RE.finditer(body):
                model.containers[cmatch.group(1)] = cmatch.group(2)
                model.container_files[cmatch.group(1)] = path

        for pmatch in PERSON_RE.finditer(text):
            model.people[pmatch.group(1)] = pmatch.group(2)
            model.person_files[pmatch.group(1)] = path

        for rmatch in REL_RE.finditer(text):
            model.relationships.append(Relationship(
                source=rmatch.group(1),
                destination=rmatch.group(2),
                description=rmatch.group(3) or "",
                technology=rmatch.group(4) or "",
                file=path,
            ))

    return model


def vocabulary() -> dict:
    """The controlled vocabularies — the single source of truth for tags,
    portfolios and property values. approved-tags.adoc documents these for
    humans; it is not parsed."""
    import json
    return json.loads((MODELS_DIR / "shared" / "vocabulary.json").read_text())


def approved_tags() -> set[str]:
    vocab = vocabulary()
    return set(vocab["portfolioCategories"]) | set(vocab["classificationTags"])
