# Apex Energy — Enterprise Architecture Knowledge Repository

Architecture-as-Code demo repository for the fictional **Apex Energy
Corporation**: a single Structurizr DSL model (C4), AsciiDoc documentation, and
pipelines that validate the model and publish a static architecture portal.

Built to the specs in [docs/spec/](docs/spec/), primarily the
[Generic Demo Edition](docs/spec/Generic_Architecture_as_Code_Demo_Spec.md).

## Links

| | URL |
|---|---|
| Repository | https://github.com/ebbypeter/project-archway |
| Architecture portal | https://ebbypeter.github.io/project-archway/ (once GitHub Pages is enabled) |
| Local preview | http://localhost:8080 (after `make site && make serve`) |

## Quick start

```bash
make setup      # one-off: downloads pinned tooling into .tools/ (no root needed)
make validate   # convention checks + authoritative DSL compile of the workspace
make site       # builds the portal into build/site/, then verifies publication
make verify     # confirm every authored document reached the site
make serve      # http://localhost:8080
```

## Dependencies

Everything except the host prerequisites is downloaded into `.tools/` by
`make setup` ([scripts/setup-tools.sh](scripts/setup-tools.sh)) — user-space,
no root, nothing installed system-wide. `.tools/` is gitignored; re-run
`make setup` on a new machine.

### Host prerequisites

| Tool | Version | Why |
|---|---|---|
| [Python](https://www.python.org/) | 3.9+ | Validation, inventory reports, docs aggregation. Standard library only — no `pip install` |
| [Bash](https://www.gnu.org/software/bash/) | 4+ | `scripts/*.sh` (the Makefile sets `SHELL := /bin/bash`) |
| GNU Make | 4+ | Task entry points |
| `curl`, `tar`, `unzip` | any | Used by `make setup` to fetch tooling |
| [Git](https://git-scm.com/) | 2.x | Source control; `scripts/env.sh` uses it to locate the repo root |

### Managed by `make setup`

| Tool | Version | Purpose | Source |
|---|---|---|---|
| Eclipse Temurin JRE | 21 (LTS) | Runs both Structurizr tools. Skipped if the host already has `java` | [adoptium.net](https://adoptium.net/) |
| Structurizr CLI | `v2025.11.09` (bundles structurizr-java 5.0.2) | Authoritative DSL compile/validate; JSON + PlantUML export | [github.com/structurizr/cli](https://github.com/structurizr/cli) |
| Structurizr Site Generatr | `1.6.0` | Renders the workspace, its AsciiDoc docs and ADRs into the static portal | [github.com/avisi-cloud/structurizr-site-generatr](https://github.com/avisi-cloud/structurizr-site-generatr) |
| Graphviz | latest from conda-forge (installed via [micromamba](https://mamba.readthedocs.io/)) | Diagram auto-layout — the site generator shells out to `dot`. Skipped if the host already has it | [graphviz.org](https://graphviz.org/) |

Exact versions are pinned at the top of
[scripts/setup-tools.sh](scripts/setup-tools.sh); bump them there.

> **Platform note:** `make setup` downloads **Linux x64** builds. On macOS,
> Windows or ARM, install Java 21 and Graphviz yourself (`make setup` then skips
> both and fetches only the two Structurizr tools), or run the repo in a
> container based on the CI image.

### Standards and formats

| | Version | Reference |
|---|---|---|
| C4 model | — | [c4model.com](https://c4model.com/) |
| Structurizr DSL | as supported by the CLI above | [docs.structurizr.com/dsl](https://docs.structurizr.com/dsl) |
| AsciiDoc | Asciidoctor (bundled in the site generator) | [docs.asciidoctor.org](https://docs.asciidoctor.org/) |
| ADRs | adr-tools Markdown format | [ADR GitHub org](https://adr.github.io/) |

### CI

Both pipelines are thin wrappers over the same Make targets — all logic lives in
`scripts/`, so a CI run and a local run do the same thing.

| Pipeline | Where it runs | Publishes to |
|---|---|---|
| [.github/workflows/portal.yml](.github/workflows/portal.yml) | GitHub Actions — the active one | GitHub Pages, from the default branch |
| [.gitlab-ci.yml](.gitlab-ci.yml) | GitLab CI — retained for the Transpower environment | GitLab Pages |

Every branch and pull request builds and uploads the portal as an artifact, so a
change can be reviewed as rendered diagrams rather than as a DSL diff.

The portal is organised by branch: `scripts/build_site.sh` derives the label
from the current branch (or the CI ref), so a `develop` build publishes at
`/develop/`. Override with `SITE_BRANCH=name`.

### Versioning

The version shown in the portal menu comes from `git describe`, so it is
meaningful in every state without any bookkeeping:

| Repository state | Version shown |
|---|---|
| Tagged commit | `v1.2.0` |
| 3 commits past the tag | `v1.2.0-3-g784ebc9` |
| Never tagged | `784ebc9` (short SHA) |
| Uncommitted changes present | suffixed `-dirty` |

To cut a release version, tag it:

```bash
git tag -a v1.0.0 -m "First published estate"
git push origin v1.0.0
```

Override for a one-off build with `SITE_VERSION=2026.08-rc1 make site`.

The `-dirty` suffix is deliberate: it marks a portal built from uncommitted
work, so a reader can tell whether what they are looking at came from reviewed,
merged content.

## What's here

| Path | What it is |
|---|---|
| `models/model.dsl` | Canonical include manifest (pipeline-enforced) |
| `models/enterprise/` | People and systems — defined once, reused everywhere. Standard views are generated; add a `views.dsl` beside a system only for custom ones |
| `models/integrations/` | First-class integration assets (DSL + interface doc + ADRs) |
| `models/solutions/` | Solution architectures (containers, components, deployment, views, docs, ADRs) |
| `models/shared/` | Controlled vocabularies (`vocabulary.json`), diagram styles, generated views |
| `workspace/` | The single published workspace: enterprise views, portal docs, ADRs |
| `docs/` | Practice standards, capabilities, policies (+ original specs) |
| `docs/templates/` | Starting points for new systems, integrations, ADRs |
| `scripts/`, `Makefile` | Validation, inventory reports, portal build — CI wraps these |
| `build/` | Generated output (gitignored); the portal lands in `build/site/` |

## Governance

- All changes via pull/merge request; `CODEOWNERS` routes reviews (federated ownership).
- The pipeline (validate → render → publish) rejects missing mandatory
  properties, values outside the controlled vocabularies, systems without
  exactly one portfolio category, capabilities with no documentation page,
  unapproved tags, duplicate definitions, naming violations, unregistered model
  fragments, and any authored document that does not reach the published portal.
- Portal publishes from the default branch: GitHub Pages today, GitLab Pages in the Transpower environment.

Start with the [contribution guide](docs/architecture-as-code/contribution-guide.adoc).
