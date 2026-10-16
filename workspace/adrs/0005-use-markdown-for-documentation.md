# 5. Use Markdown for documentation

Date: 2026-10-16

## Status

Accepted

Amends [1. Adopt Architecture-as-Code](0001-adopt-architecture-as-code.md)

## Context

ADR 1 chose AsciiDoc for documentation. Most people who edit this repository
change one or two items, or only make an occasional update. AsciiDoc's syntax
(`|===` tables, `[cols]` attributes, `----` blocks, `image::` macros) is
unfamiliar to them and gets in their way, while nearly everyone already knows
Markdown from READMEs, wikis and chat tools. The ADRs were already Markdown, so
the repository used two formats.

## Decision

All documentation — system, solution, integration and workspace pages,
practice standards, policies and capabilities — is written in Markdown
(CommonMark with GitHub-style tables). Diagrams are embedded with
`![Title](embed:<ViewKey>)`; anything Markdown cannot express is written as
inline HTML.

## Consequences

* One format for documentation and ADRs, and one that occasional contributors
  already know and that renders on Git hosting previews.
* Markdown has no column-width or table-attribute syntax and no admonitions,
  so those are dropped or written as blockquotes / HTML.
* The generators and validators (`scripts/aggregate_docs.py`,
  `generate_reports.py`, `new_system.py`, `validate_model.py`) read and write
  Markdown.
