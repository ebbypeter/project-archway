workspace "Apex Energy — Enterprise" "Enterprise landscape and portfolio views for Enterprise Architects, ARB and leadership." {

    !docs docs
    !adrs adrs

    model {
        !include ../../models/model.dsl
    }

    views {

        properties {
            "generatr.site.exporter" "structurizr"
        }

        systemLandscape "EnterpriseLandscape" "All people, enterprise systems, solutions and integrations." {
            include *
            autoLayout lr
        }

        systemContext gridView "GridView-Context" "GridView and its direct dependencies." {
            include *
            autoLayout lr
        }

        systemContext assetHub "AssetHub-Context" "AssetHub and its direct dependencies." {
            include *
            autoLayout lr
        }

        systemContext insightLake "InsightLake-Context" "InsightLake and the systems feeding it." {
            include *
            autoLayout lr
        }

        container networkIntelligence "NetworkIntelligence-Containers" "Containers of the Network Intelligence solution." {
            include *
            autoLayout lr
        }

        container assetModernization "AssetModernization-Containers" "Containers of the Asset Modernization solution." {
            include *
            autoLayout lr
        }

        !include ../../models/shared/styles/element-styles.dsl
        !include ../../models/shared/styles/relationship-styles.dsl
    }
}
