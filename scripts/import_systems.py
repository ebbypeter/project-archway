#!/usr/bin/env python3
"""Bulk-create systems from a CSV export (CMDB, spreadsheet, asset register).

Nobody hand-authors 300 systems. This maps an existing export onto the model so
architects start from a populated estate and refine, rather than typing it in.

    make import-systems FILE=estate.csv

Required columns : name, category, owner, capability, lifecycle, criticality
Optional columns : description, hosting, runtime, database, supportTeam, vendor

The import is strict by design: it validates every row against the controlled
vocabularies FIRST and writes nothing unless all rows pass, so a 300-row file
never leaves the repository half-imported. Value-mapping problems (a CMDB that
says "PROD" where the model says "Production") surface as one report you can
fix in the spreadsheet and re-run.
"""

from __future__ import annotations

import csv
import json
import sys
from pathlib import Path

from dsl_model import ROOT
from new_system import SYSTEMS_DIR, scaffold

VOCABULARY = json.loads((ROOT / "models/shared/vocabulary.json").read_text())
REQUIRED = ["name", "category", "owner", "capability", "lifecycle", "criticality"]
OPTIONAL = ["description", "hosting", "runtime", "database", "supportTeam", "vendor"]


def known_capabilities() -> set[str]:
    return {
        p.stem.replace("-", " ").lower()
        for p in (ROOT / "docs/capabilities").glob("*.adoc")
    }


def check(rows: list[dict]) -> list[str]:
    problems = []
    capabilities = known_capabilities()
    seen = set()

    for number, row in enumerate(rows, start=2):  # row 1 is the header
        name = (row.get("name") or "").strip()
        if not name:
            problems.append(f"row {number}: missing name")
            continue
        if name in seen:
            problems.append(f"row {number}: duplicate name '{name}'")
        seen.add(name)
        if (SYSTEMS_DIR / name.replace(" ", "")).exists():
            problems.append(f"row {number}: '{name}' already exists in the model")

        for column in REQUIRED[1:]:
            if not (row.get(column) or "").strip():
                problems.append(f"row {number} ({name}): missing {column}")

        category = (row.get("category") or "").strip()
        if category and category not in VOCABULARY["portfolioCategories"]:
            problems.append(
                f"row {number} ({name}): category '{category}' not in "
                f"{VOCABULARY['portfolioCategories']}"
            )
        for column in ("lifecycle", "criticality", "hosting"):
            value = (row.get(column) or "").strip()
            allowed = VOCABULARY["properties"].get(column, [])
            if value and value not in allowed:
                problems.append(
                    f"row {number} ({name}): {column} '{value}' not in {allowed}"
                )
        capability = (row.get("capability") or "").strip()
        if capability and capability.replace("&", "and").lower() not in capabilities:
            problems.append(
                f"row {number} ({name}): capability '{capability}' has no page "
                f"in docs/capabilities/"
            )
    return problems


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: make import-systems FILE=estate.csv", file=sys.stderr)
        return 2
    path = Path(sys.argv[1])
    if not path.is_file():
        print(f"{path} not found", file=sys.stderr)
        return 2

    rows = list(csv.DictReader(path.open()))
    if not rows:
        print("no rows found", file=sys.stderr)
        return 2

    missing_columns = [c for c in REQUIRED if c not in rows[0]]
    if missing_columns:
        print(f"CSV is missing required column(s): {', '.join(missing_columns)}",
              file=sys.stderr)
        return 1

    problems = check(rows)
    if problems:
        print(f"Import rejected — {len(problems)} problem(s), nothing written:\n",
              file=sys.stderr)
        for problem in problems[:40]:
            print(f"  ✗ {problem}", file=sys.stderr)
        if len(problems) > 40:
            print(f"  … and {len(problems) - 40} more", file=sys.stderr)
        print("\nFix the source file and re-run.", file=sys.stderr)
        return 1

    for row in rows:
        properties = {
            key: (row.get(key) or "").strip()
            for key in ["description", "owner", "capability", "lifecycle",
                        "criticality", "hosting", "runtime", "database",
                        "supportTeam", "vendor"]
        }
        scaffold(row["name"].strip(), row["category"].strip(), properties, quiet=True)

    print(f"Imported {len(rows)} systems.\nNext: `make views` then `make validate`.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
