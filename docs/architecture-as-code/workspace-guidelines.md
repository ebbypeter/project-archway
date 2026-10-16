# Workspace Guidelines

The repository publishes a **single workspace** — the enterprise picture — as the
architecture portal. Audience needs (technology inventory, trust views,
integration catalogue) are served by documentation pages and generated reports
within it, not by separate workspaces.

## Where views live

Views are defined **next to the elements they show** and pulled into the
workspace's `views` block by `!include`:

| Views | Location |
|---|---|
| System context views | `models/enterprise/systems/<Name>/views.dsl` |
| Solution container / component / deployment views | `models/solutions/<Name>/views/views.dsl` |
| Enterprise-level views (landscape, tag-scoped, dynamic) | `workspace/workspace.dsl` |
| Shared styles | `models/shared/styles/` |

## Rules

1. The workspace includes the model **only** via `!include ../models/model.dsl`
   and never defines elements of its own.
2. A new system or solution ships its views file alongside its definition, and
   the workspace adds one `!include` for it.
3. Workspace-scoped views (landscapes, dynamic views) are not shown by the site
   generator on system pages — give each one a documentation page that embeds it
   with `![Title](embed:<ViewKey>)` (see `workspace/docs/0*.md`).
4. Creating an additional workspace (e.g. a restricted-audience one) needs
   Architecture Practice approval and its own entry in `scripts/build_site.sh`.

## Multi-page element documentation

An element's `docs/` folder may hold several `.md` files; each becomes a
numbered section under that element's **Documentation** tab, ordered by filename
(`01-`, `02-`, …). The site generator lists them only on the section index, so
`scripts/inject_section_nav.py` adds sibling tabs and previous/next links to
each section page at build time — no action needed when adding a file.

## Hand-written views

The generated views show everything around an element. When a diagram should
tell one specific story, write the view by hand in the asset's `views.dsl`. It
is still drawn from the model — every element and step must exist there — so
it cannot drift the way a drawing can. Examples in this repository:

| Kind | Example | Where it is shown |
|---|---|---|
| Dynamic view of a user journey, at container level | `AssetModernization-InspectionSync` in `models/solutions/AssetModernization/views/views.dsl` | Asset Modernization → *Dynamic views*, and the *User Journeys* page |
| Focused view — the full container view minus people, for an integration review | `AssetModernization-Integration`, same file | Asset Modernization → *Container views*, and the *Security and Integration* page |
| Dynamic view inside one container, at component level, with parallel steps (`3a:` / `3b:`) | `AnalyticsApi-DashboardQuery` in `models/solutions/NetworkIntelligence/views/views.dsl` | Network Intelligence → *Dynamic views*, and the solution overview |

Each step of a dynamic view follows an existing relationship; the text after
it describes the step in this story and may differ from the relationship's own
description. Embed any view on a documentation page with
`![Title](embed:<ViewKey>)`.

### Layout is automatic

Element positions cannot be arranged by hand in this portal. The site
generator draws every diagram through PlantUML, which always computes its own
layout (with Graphviz) and ignores stored positions — so layout saved by the
Structurizr editor in a `workspace.json` has no effect here. What an author
controls is the layout direction (`autoLayout lr` or `tb`) and what the view
includes and excludes; a crowded diagram is best fixed by narrowing its scope
or splitting it into two views.
