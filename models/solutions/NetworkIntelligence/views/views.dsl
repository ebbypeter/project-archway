# Views for the Network Intelligence solution — kept next to the architecture
# they visualise (see ../architecture/). Included by the workspace views block.

container networkIntelligence "NetworkIntelligence-Containers" "C4 level 2: containers of the Network Intelligence solution." {
    include *
    autoLayout lr
}

component analyticsApi "AnalyticsApi-Components" "C4 level 3: components inside the Analytics API container." {
    include *
    autoLayout lr
}

deployment networkIntelligence "Production" "NetworkIntelligence-Deployment" "Production deployment of the Network Intelligence solution." {
    include *
    autoLayout lr
}

# --- Hand-written views ---
# Authored to tell a specific story, but still drawn from the model: every
# element and step must exist there, so the view cannot drift from it.

# Dynamic view at component level: how one dashboard request is served inside
# the Analytics API. Steps 3a/3b run side by side: the marts answer the
# pre-aggregated part, InsightLake the detail.
dynamic analyticsApi "AnalyticsApi-DashboardQuery" "How a dashboard request is served inside the Analytics API." {
    1: networkPortal -> insightController "Requests a network dashboard from"
    2: insightController -> insightService "Asks for the dashboard's datasets"
    3a: insightService -> martRepository "Fetches pre-aggregated figures via"
    3b: insightService -> lakeGateway "Fetches detail rows via"
    4a: martRepository -> reportingDb "Reads the reporting marts in"
    4b: lakeGateway -> insightLake "Runs a federated query against"
    autoLayout lr
}
