# 1. Query InsightLake directly instead of replicating all data

Date: 2026-08-30

## Status

Accepted

## Context

The Analytics API needs both low-latency aggregates and ad-hoc access to the
full curated network datasets. Replicating all datasets into the solution's own
database would duplicate InsightLake and create a second source of truth.

## Decision

Query InsightLake directly for ad-hoc analytics; maintain only pre-aggregated
reporting marts in the local Reporting Database.

## Consequences

* No bulk data duplication; InsightLake remains the analytics source of truth.
* The solution depends on InsightLake availability for ad-hoc queries.
* Mart refresh jobs must be monitored by the solution team.
