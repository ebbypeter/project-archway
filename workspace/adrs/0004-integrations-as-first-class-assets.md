# 4. Model integrations as first-class assets

Date: 2026-08-30

## Status

Accepted

## Context

Integrations are usually documented (if at all) inside one of the two systems
they connect, so ownership is ambiguous and interface knowledge is lost when a
system is replaced.

## Decision

Each integration is a standalone asset in `models/integrations/<Source-Target>/`
containing the relationship definition, interface documentation and its own
ADRs, owned by an Integration Owner — not by the source or target system.

## Consequences

* Interfaces survive system replacements as documented, owned assets.
* The interface catalogue can be generated directly from the repository.
* Contributors must resist the habit of defining relationships inside system files.
