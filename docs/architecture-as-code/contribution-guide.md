# Contribution Guide

## Workflow

1. Branch from `main`.
2. Make your model/documentation change (start from `docs/templates/`).
3. Register any new `.dsl` file in `models/model.dsl`.
4. Run `make validate` locally (first time: `make setup`).
5. Open a merge request. CODEOWNERS routes it to the right reviewers:
   enterprise/shared assets to Architecture Practice, integrations to the
   Integration Owner, solutions to the Solution Architect.
6. On merge to `main`, the pipeline republishes the portal.

## Adding an enterprise system

Use the generator — it offers the controlled vocabularies as choices, writes
every file, and registers the system in the manifest:

```bash
make new-system
```

Then fill in the TODOs in the generated `docs/01-overview.md` and run
`make validate`. The standard context view is generated for you; add a
`views.dsl` beside the system only if you need something other than the
standard view.

To bootstrap an estate from a CMDB or spreadsheet export:

```bash
make import-systems FILE=estate.csv
```

The import validates every row before writing anything, so a large file never
lands half-imported.

## Adding an integration

1. Folder `models/integrations/<Source>-<Target>/`.
2. `relationship.dsl`, `docs/interface.md` (all rows completed), `adr/` as needed.
3. Include it from `models/model.dsl`.

## Local commands

| Command | Purpose |
|---|---|
| `make setup` | Download tooling into `.tools/` (one-off) |
| `make validate` | Convention checks + DSL compile of the workspace |
| `make site` | Full portal build into `build/site/` (ends with the publication check) |
| `make verify` | Confirm every authored document reached the built site |
| `make serve` | Serve the portal at http://localhost:8080 |

## Documentation must be published, not just written

`make site` fails if any authored `.md` document or ADR is missing from the built
portal. Documentation is attached to **elements**:

* System docs — `!docs docs` in `system.dsl`.
* Solution docs and decisions — `!docs ../docs` and `!adrs ../adr` in the
  solution's `softwareSystem` block.
* Integration docs and decisions — integrations are **relationships**, which
  cannot carry documentation, so `scripts/generate_reports.py` inlines them
  into the generated Interface Catalogue.

Deliberately unpublished paths are listed in `EXCLUDED` in
`scripts/verify_published.py`; add to it only with a stated reason.
