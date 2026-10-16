# Repository Structure

| Path | Contents |
|---|---|
| `models/model.dsl` | Canonical include manifest — every model fragment is listed here, in dependency order. Pipeline-enforced. |
| `models/enterprise/people/` | Canonical person definitions, one file per business domain. |
| `models/enterprise/systems/<Name>/` | One folder per enterprise system: `system.dsl` + `views.dsl` + `docs/` (Markdown). |
| `models/integrations/<A-B>/` | First-class integration assets: `relationship.dsl`, `docs/interface.md`, `adr/`. |
| `models/solutions/<Name>/` | Solution architectures: `architecture/*.dsl`, `views/views.dsl`, `docs/`, `adr/`. |
| `models/shared/` | Approved tags and shared styles. Architecture Practice owned. |
| `workspace/` | The single published workspace: enterprise-level views, portal documentation, ADRs. Never element definitions. |
| `docs/` | Practice standards, capabilities, policies — the single source of truth; published into the Enterprise workspace section of the portal at build time (`scripts/aggregate_docs.py`). `docs/spec/` (the original specifications) is not published. |
| `docs/templates/` | Copy-paste starting points for new systems, integrations and ADRs. |
| `scripts/` + `Makefile` | Validation, reporting and site build. CI is a thin wrapper over these. |

## Golden rules

1. Systems and people are defined **once**, under `models/enterprise/`.
2. System-to-system relationships live **only** in `models/integrations/`.
3. Workspaces consume the model; they never define elements.
4. Every new `.dsl` fragment is registered in `models/model.dsl`.
