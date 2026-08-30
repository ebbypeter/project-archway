# 1. Adopt Architecture-as-Code

Date: 2026-08-30

## Status

Accepted

## Context

Architecture knowledge was scattered across drawing tools, wikis and slide
decks. Diagrams drifted from reality, systems were described differently in
every document, and there was no way to report on the technology estate.

## Decision

Adopt Architecture-as-Code: a single Structurizr DSL model in Git as the source
of truth, C4 for visualisation, AsciiDoc for documentation, and CI/CD pipelines
that validate the model and publish an architecture portal.

## Consequences

* Systems and people are defined once and reused across all views.
* All changes go through merge requests with CODEOWNERS-based review.
* Diagrams and inventories are generated, never hand-drawn.
* Contributors must learn the Structurizr DSL and repository conventions.
