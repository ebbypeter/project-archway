# Apex Energy — Enterprise Architecture Knowledge Repository

Architecture-as-Code demo repository for the fictional **Apex Energy
Corporation**: a single Structurizr DSL model (C4), AsciiDoc documentation, and
pipelines that validate the model and publish a static architecture portal.

Built to the specs in [docs/spec/](docs/spec/), primarily the
[Generic Demo Edition](docs/spec/Generic_Architecture_as_Code_Demo_Spec.md).

## Quick start

```bash
make setup      # one-off: downloads JRE (if needed), structurizr-cli, site-generatr into .tools/
make validate   # convention checks + DSL compile of all four workspaces
make site       # builds the portal into public/
make serve      # http://localhost:8080
```

## What's here

| Path | What it is |
|---|---|
| `models/model.dsl` | Canonical include manifest (pipeline-enforced) |
| `models/enterprise/` | People and systems — defined once, reused everywhere; each system's views live beside it (`views.dsl`) |
| `models/integrations/` | First-class integration assets (DSL + interface doc + ADRs) |
| `models/solutions/` | Solution architectures (containers, components, deployment, views, docs, ADRs) |
| `models/shared/` | Approved tags and shared diagram styles |
| `workspace/` | The single published workspace: enterprise views, portal docs, ADRs |
| `docs/` | Practice standards, capabilities, policies (+ original specs) |
| `docs/templates/` | Starting points for new systems, integrations, ADRs |
| `scripts/`, `Makefile` | Validation, inventory reports, portal build — CI wraps these |

## Governance

- All changes via merge request; `CODEOWNERS` routes reviews (federated ownership).
- The pipeline (`.gitlab-ci.yml`: validate → render → publish) rejects missing
  mandatory properties, unapproved tags, duplicate definitions, naming
  violations, and unregistered model fragments.
- Portal publishes to GitLab Pages from `main`.

Start with the [contribution guide](docs/architecture-as-code/contribution-guide.adoc).
