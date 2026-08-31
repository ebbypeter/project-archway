#!/usr/bin/env python3
"""Validate repository modelling conventions.

Checks (beyond what structurizr-cli's compile validates):
  1. Mandatory properties on every software system.
  2. Only approved tags are used on software systems.
  3. No duplicate identifiers or duplicate system names.
  4. Naming standards (no environment/type suffixes in system names).
  5. Every model fragment is listed in the canonical manifest (models/model.dsl).
  6. Every relationship has a description.

Exit code is non-zero if any check fails.
"""

from __future__ import annotations

import json
import re
import sys
from collections import Counter
from pathlib import Path

from dsl_model import ROOT, approved_tags, manifest_includes, model_dsl_files, parse_model

MANDATORY_PROPERTIES = ("owner", "capability", "lifecycle", "criticality")
FORBIDDEN_NAME_TOKENS = ("PROD", "SYSTEM", "TEST", "UAT", "DEV")


def rel(path: Path) -> str:
    return str(path.relative_to(ROOT))


def main() -> int:
    model = parse_model()
    tags_allowed = approved_tags()
    errors: list[str] = []

    # 1. Mandatory properties
    for system in model.systems:
        for prop in MANDATORY_PROPERTIES:
            if not system.properties.get(prop):
                errors.append(
                    f"{rel(system.file)}: system '{system.name}' is missing "
                    f"mandatory property '{prop}'"
                )

    # 2. Approved tags only
    for system in model.systems:
        for tag in system.tags:
            if tag not in tags_allowed:
                errors.append(
                    f"{rel(system.file)}: system '{system.name}' uses "
                    f"unapproved tag '{tag}' (approved: {', '.join(sorted(tags_allowed))})"
                )

    # 3. Duplicate identifiers and system names
    identifiers = (
        [s.identifier for s in model.systems]
        + list(model.people)
        + list(model.containers)
    )
    for identifier, count in Counter(identifiers).items():
        if count > 1:
            errors.append(f"duplicate identifier '{identifier}' defined {count} times")
    for name, count in Counter(s.name for s in model.systems).items():
        if count > 1:
            errors.append(f"duplicate software system name '{name}' defined {count} times")

    # 3b. Controlled vocabularies — a typo here silently corrupts the
    # inventory reports rather than failing anything, so it must be caught.
    vocabulary = json.loads((ROOT / "models/shared/vocabulary.json").read_text())
    for prop, allowed in vocabulary["properties"].items():
        for system in model.systems:
            value = system.properties.get(prop)
            if value and value not in allowed:
                errors.append(
                    f"{rel(system.file)}: system '{system.name}' has "
                    f"{prop} '{value}', which is not in the controlled "
                    f"vocabulary ({', '.join(allowed)})"
                )

    # 3c. Every system belongs to exactly one portfolio category.
    categories = set(vocabulary["portfolioCategories"])
    for system in model.systems:
        assigned = [t for t in system.tags if t in categories]
        if len(assigned) != 1:
            errors.append(
                f"{rel(system.file)}: system '{system.name}' must carry exactly "
                f"one portfolio category tag ({', '.join(sorted(categories))}); "
                f"found {assigned or 'none'}"
            )

    # 3d. Every declared capability has a documentation page.
    capability_docs = {
        p.stem.replace("-", " ").lower()
        for p in (ROOT / "docs/capabilities").glob("*.adoc")
    }
    for system in model.systems:
        capability = system.properties.get("capability")
        if capability:
            slug = capability.replace("&", "and").replace("  ", " ").lower()
            if slug not in capability_docs and slug.replace(" ", " ") not in capability_docs:
                errors.append(
                    f"{rel(system.file)}: system '{system.name}' declares "
                    f"capability '{capability}' with no matching page in "
                    f"docs/capabilities/"
                )

    # 4. Naming standards
    for system in model.systems:
        for token in FORBIDDEN_NAME_TOKENS:
            if re.search(rf"\b{token}\b", system.name, flags=0):
                errors.append(
                    f"{rel(system.file)}: system name '{system.name}' violates naming "
                    f"standards (contains '{token}')"
                )

    # 5. Manifest completeness
    manifest = {p for p in manifest_includes()}
    for path in model_dsl_files():
        if path.resolve() not in manifest:
            errors.append(
                f"{rel(path)} is not reachable from models/model.dsl — every model "
                f"fragment must be included via the canonical manifest"
            )
    for path in manifest:
        if not path.exists():
            errors.append(f"models/model.dsl references missing file {path}")

    # 6. Relationship descriptions
    for relationship in model.relationships:
        if not relationship.description.strip():
            errors.append(
                f"{rel(relationship.file)}: relationship "
                f"{relationship.source} -> {relationship.destination} has no description"
            )

    if errors:
        print(f"Model validation FAILED with {len(errors)} error(s):\n", file=sys.stderr)
        for error in errors:
            print(f"  ✗ {error}", file=sys.stderr)
        return 1

    print(
        f"Model validation passed: {len(model.systems)} systems, "
        f"{len(model.people)} people, {len(model.containers)} containers, "
        f"{len(model.relationships)} relationships."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
