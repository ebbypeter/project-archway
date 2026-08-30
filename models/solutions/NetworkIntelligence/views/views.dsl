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
