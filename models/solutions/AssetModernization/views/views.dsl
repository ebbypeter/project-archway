# Views for the Asset Modernization solution — kept next to the architecture
# they visualise (see ../architecture/). Included by the workspace views block.

systemContext assetModernization "AssetModernization-Context" "AssetModernization and its direct dependencies." {
    include *
    autoLayout tb
}

container assetModernization "AssetModernization-Containers" "C4 level 2: containers of the Asset Modernization solution." {
    include *
    autoLayout lr
}

# --- Hand-written views ---
# The two views above are the standard "show everything" pair. The views below
# are authored to tell a specific story, but they are still drawn from the
# model: every element and step must exist there, so they cannot drift from it.

# Dynamic view: the inspection journey as numbered steps. Each step follows a
# relationship in the model; the text after it describes the step in this
# story and can differ from the relationship's own description.
dynamic assetModernization "AssetModernization-InspectionSync" "An inspection round, from planning to AssetHub." {
    assetPlanner -> fieldApp "Assigns a week's inspection route in"
    fieldApp -> identityCloud "Signs the field crew in via (OIDC, before going offline)"
    fieldApp -> assetSyncService "Uploads queued inspection results to, once back in coverage"
    assetSyncService -> assetHub "Writes validated condition records to"
    autoLayout lr
}

# Focused view: only what the security and integration review needs — the
# solution's containers and the enterprise systems they touch, without people.
container assetModernization "AssetModernization-Integration" "Containers and the enterprise systems they integrate with, without people." {
    include *
    exclude "element.type==Person"
    autoLayout lr
}
