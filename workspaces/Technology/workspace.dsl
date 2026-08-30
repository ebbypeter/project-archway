workspace "Apex Energy — Technology" "Technology inventory and lifecycle views for technology leadership and lifecycle managers." {

    !docs docs
    !adrs adrs

    model {
        !include ../../models/model.dsl
    }

    views {

        properties {
            "generatr.site.exporter" "structurizr"
        }

        systemLandscape "TechnologyLandscape" "All enterprise systems; use the Technology and Lifecycle perspectives, and see the generated inventory reports in the documentation." {
            include *
            autoLayout lr
        }

        !include ../../models/shared/styles/element-styles.dsl
        !include ../../models/shared/styles/relationship-styles.dsl
    }
}
