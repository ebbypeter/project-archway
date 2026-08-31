group "Critical Apps" {
    assetHub = softwareSystem "AssetHub" {
        description "Asset management platform for the enterprise asset base."

        tags "EnterpriseSystem" "Critical Apps" "CriticalSystem"

        properties {
            owner "Asset Management"
            capability "Asset Management"
            lifecycle "Production"
            criticality "High"
            runtime "Java 21"
            database "PostgreSQL"
            hosting "Cloud"
            supportTeam "Asset Systems Support"
        }

        perspectives {
            "Technology" "Java 21 / PostgreSQL / Cloud"
            "Lifecycle" "Production"
            "Ownership" "Asset Management"
            "Criticality" "High"
        }

        !docs docs
    }
}

assetPlanner -> assetHub "Plans asset investments and maintenance in"
systemAdministrator -> assetHub "Administers"
