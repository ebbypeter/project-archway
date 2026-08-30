# 1. Use event streaming for telemetry publication

Date: 2026-08-30

## Status

Accepted

## Context

GridView produces continuous operational telemetry. InsightLake needs this data
with low latency for operational analytics. Batch file transfer was considered
but introduces multi-minute delays and brittle file-handling logic.

## Decision

Publish telemetry as an event stream with AVRO payloads over TLS,
authenticated via IdentityCloud client credentials.

## Consequences

* Near real-time availability of telemetry in InsightLake.
* Schema evolution must be managed via a schema registry and ADRs.
* Consumers must handle replay and at-least-once delivery.
