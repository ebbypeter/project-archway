## User Journeys

The whole round at a glance — each numbered step is one hop through the
architecture:

![Inspection round, from planning to AssetHub](embed:AssetModernization-InspectionSync)

### Planning an inspection round (Asset Planner)

1. The Asset Planner reviews due and overdue inspections in the Field
   Inspection App's planning module, grouped by route.
2. They assign a week's route to a field crew; the app pre-downloads asset
   records, forms and defect catalogues for offline use.
3. Progress is visible as crews sync; slipped work is re-planned the same day.

### Inspecting in the field (Field Crew)

1. At the asset, the crew opens the pre-downloaded inspection form — no
   connectivity required.
2. They capture condition ratings, defect codes and photos; entries are
   validated on-device against the form rules and GPS-stamped.
3. Completed inspections queue locally (encrypted at rest, per the offline-first
   ADR).
4. When coverage returns, the app uploads the queue to the Asset Sync Service
   with resumable, at-least-once delivery.

### From upload to AssetHub (automated)

1. The Asset Sync Service validates each payload: schema, defect catalogue
   versions, plausibility rules (e.g. condition score deltas).
2. Valid results update asset condition records in AssetHub the same day;
   rejects go to a review queue with the reason attached.
3. Conflicts (same asset edited twice) resolve last-writer-wins per field, with
   both versions kept in the audit trail.
