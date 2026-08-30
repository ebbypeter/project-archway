# 1. Offline-first design for the Field Inspection App

Date: 2026-08-30

## Status

Accepted

## Context

Field crews inspect assets in remote locations with unreliable connectivity.
A connected-only app would block inspections in exactly the places where the
asset base is hardest to maintain.

## Decision

Design the Field Inspection App offline-first: inspections are captured locally
and synchronised to the Asset Sync Service when connectivity returns.

## Consequences

* Inspections proceed regardless of coverage.
* Conflict resolution rules are required when the same asset is edited twice.
* Local storage of inspection data must be encrypted at rest.
