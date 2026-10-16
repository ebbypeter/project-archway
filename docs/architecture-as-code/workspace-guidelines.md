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
