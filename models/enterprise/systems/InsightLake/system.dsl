insightLake = softwareSystem "InsightLake" {
    description "Enterprise analytics platform for curated data, reporting and dashboards."

    tags "EnterpriseSystem" "Platform"

    properties {
        owner "Data & Analytics"
        capability "Data & Analytics"
        lifecycle "Production"
        criticality "Medium"
        runtime "InsightLake Cloud Engine"
        hosting "Cloud"
        vendor "InsightLake Inc."
        supportTeam "Analytics Platform Team"
    }

    perspectives {
        "Technology" "InsightLake Cloud Engine / Cloud"
        "Lifecycle" "Production"
        "Ownership" "Data & Analytics"
        "Criticality" "Medium"
    }

    !docs docs
}

dataAnalyst -> insightLake "Builds analyses and reports in"
businessManager -> insightLake "Consumes dashboards and reports from"
