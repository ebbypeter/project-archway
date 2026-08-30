workspace "Apex Energy — Integration" "Integration landscape, data flows and the interface catalogue for Integration Architects." {

    !docs docs
    !adrs adrs

    model {
        !include ../../models/model.dsl
    }

    views {

        properties {
            "generatr.site.exporter" "structurizr"
        }

        systemLandscape "IntegrationLandscape" "All systems and the integrations connecting them." {
            include *
            autoLayout lr
        }

        dynamic * "TelemetryToInsight" "How operational telemetry becomes business insight." {
            gridView -> insightLake "Publishes operational telemetry"
            businessManager -> insightLake "Consumes dashboards and reports from"
            autoLayout lr
        }

        !include ../../models/shared/styles/element-styles.dsl
        !include ../../models/shared/styles/relationship-styles.dsl
    }
}
