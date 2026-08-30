# Solution: Network Intelligence Program
# Owned by: Solution Architect (see CODEOWNERS).
# Containers, components and solution-level relationships live here — never in enterprise/.

networkIntelligence = softwareSystem "Network Intelligence" {
    description "Network Intelligence Program: self-service network analytics for operations and leadership."

    tags "EnterpriseSystem"

    properties {
        owner "Network Operations"
        capability "Network Operations"
        lifecycle "Production"
        criticality "Medium"
        runtime ".NET 10"
        database "PostgreSQL"
        hosting "Cloud"
    }

    networkPortal = container "Network Portal" "Web UI for exploring network intelligence insights." "React"
    analyticsApi = container "Analytics API" "Serves curated network analytics to the portal." ".NET 10"
    reportingDb = container "Reporting Database" "Pre-aggregated reporting marts." "PostgreSQL"

    !docs ../docs
}

# Container relationships
networkPortal -> analyticsApi "Retrieves analytics via" "HTTPS/JSON"
analyticsApi -> reportingDb "Reads and writes" "SQL"
analyticsApi -> insightLake "Queries curated network datasets in" "HTTPS/SQL"
networkPortal -> identityCloud "Authenticates users via" "OIDC"

# People
operationsEngineer -> networkPortal "Explores network insights using"
businessManager -> networkPortal "Views network dashboards in"
