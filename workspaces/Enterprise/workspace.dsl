workspace "Apex Energy — Architecture" "Enterprise Architecture Knowledge Repository for Apex Energy Corporation." {

    !docs docs
    !adrs adrs

    model {
        !include ../../models/model.dsl
    }

    views {

        properties {
            "generatr.site.exporter" "structurizr"
        }

        # --- Enterprise-level views (owned by this workspace) ---

        systemLandscape "EnterpriseLandscape" "All people, enterprise systems, solutions and integrations." {
            include *
            autoLayout tb
        }

        # Tag-scoped view: only the external trust surface. (Structurizr also has
        # `filtered` views, but the site generator does not render those, so we
        # scope a real view with an element expression instead.)
        systemLandscape "VendorHostedSystems" "Only vendor-hosted and SaaS systems — the external trust surface." {
            include "element.tag==VendorHosted || element.tag==SaaS"
            autoLayout lr
        }

        dynamic * "TelemetryToInsight" "How operational telemetry becomes business insight." {
            gridView -> insightLake "Publishes operational telemetry"
            businessManager -> insightLake "Consumes dashboards and reports from"
            autoLayout lr
        }

        # --- System views, defined next to each system ---

        !include ../../models/enterprise/systems/AssetHub/views.dsl
        !include ../../models/enterprise/systems/GridView/views.dsl
        !include ../../models/enterprise/systems/IdentityCloud/views.dsl
        !include ../../models/enterprise/systems/InsightLake/views.dsl
        !include ../../models/enterprise/systems/NotifyNow/views.dsl
        !include ../../models/enterprise/systems/ServiceDeskPro/views.dsl

        # --- Solution views, defined next to each solution ---

        !include ../../models/solutions/AssetModernization/views/views.dsl
        !include ../../models/solutions/NetworkIntelligence/views/views.dsl

        # --- Shared styles ---

        !include ../../models/shared/styles/element-styles.dsl
        !include ../../models/shared/styles/relationship-styles.dsl
    }
}
