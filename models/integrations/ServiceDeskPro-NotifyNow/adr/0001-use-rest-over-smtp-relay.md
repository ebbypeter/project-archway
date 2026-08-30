# 1. Use the NotifyNow REST API instead of an SMTP relay

Date: 2026-08-30

## Status

Accepted

## Context

ServiceDeskPro can notify stakeholders either through a legacy SMTP relay or the
NotifyNow REST API. The SMTP relay offers no delivery tracking and no channel
choice (email only).

## Decision

Use the NotifyNow REST API with JSON payloads, allowing NotifyNow to select the
delivery channel (email, SMS, push) per recipient preference.

## Consequences

* Delivery status is trackable; failures raise webhooks.
* An API key must be managed and rotated by the Digital Workplace Team.
* The legacy SMTP relay can be retired.
