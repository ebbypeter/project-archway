# 1. Centralise workforce authentication on IdentityCloud

Date: 2026-08-30

## Status

Accepted

## Context

Enterprise systems each shipped with local account stores. Password sprawl made
joiner/mover/leaver processes unreliable and audits slow.

## Decision

All enterprise systems authenticate the workforce via IdentityCloud using OIDC
where the product supports it, SAML 2.0 otherwise. Local accounts are limited
to break-glass access.

## Consequences

* Single joiner/mover/leaver process and central MFA enforcement.
* IdentityCloud availability is now critical (criticality: High).
* SAML-only systems carry a migration note in their integration docs.
