workspace "Apex Energy — Architecture" "Enterprise Architecture Knowledge Repository for Apex Energy Corporation." {

    !docs docs
    !adrs adrs

    model {
        !include ../models/model.dsl
    }

    views {

        properties {
            "generatr.site.exporter" "structurizr"
        }

        # --- Enterprise-level views (owned by this workspace) ---

        # Scale limit (measured): a landscape stops being readable and starts
        # taking minutes to render past ~60 elements — at 195 it is a 65,000px
        # strip, at 300 the build stalls. These whole-estate views are viable
        # for the demo model only; at Transpower scale use the per-category
        # landscapes in views-generated.dsl and delete these two.
        systemLandscape "EnterpriseLandscape" "All people, enterprise systems, solutions and integrations." {
            include *
            autoLayout tb
        }

        systemLandscape "SystemsOnlyLandscape" "Enterprise systems, solutions and integrations — without people." {
            include *
            exclude "element.type==Person"
            autoLayout lr
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

        # --- Generated views: standard per-system context views and one
        # landscape per portfolio category. Regenerate with `make views`.
        # A system only needs a hand-written views.dsl if it wants something
        # other than the standard context view.

        !include ../models/shared/views-generated.dsl

        # --- Solution views, defined next to each solution ---

        !include ../models/solutions/AssetModernization/views/views.dsl
        !include ../models/solutions/NetworkIntelligence/views/views.dsl

        # --- Shared styles ---

        !include ../models/shared/styles/element-styles.dsl
        !include ../models/shared/styles/relationship-styles.dsl
    }
}
