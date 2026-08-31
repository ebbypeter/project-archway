# Solution: Asset Modernization Program
# Owned by: Solution Architect (see CODEOWNERS).

group "Critical Apps" {
    assetModernization = softwareSystem "Asset Modernization" {
        description "Asset Modernization Program: mobile field inspections synchronised into AssetHub."

        tags "EnterpriseSystem" "Critical Apps"

        properties {
            owner "Asset Management"
            capability "Asset Management"
            lifecycle "Production"
            criticality "Medium"
            runtime "Kotlin / Java 21"
            hosting "Cloud"
        }

        fieldApp = container "Field Inspection App" "Offline-capable mobile app for asset inspections." "Kotlin Multiplatform"
        assetSyncService = container "Asset Sync Service" "Validates and synchronises inspection results into AssetHub." "Java 21"

        !docs ../docs
        !adrs ../adr
    }
}

# Container relationships
fieldApp -> assetSyncService "Uploads inspection results to" "HTTPS/JSON"
assetSyncService -> assetHub "Updates asset condition records in" "HTTPS/REST"
fieldApp -> identityCloud "Authenticates users via" "OIDC"

# People
assetPlanner -> fieldApp "Reviews and schedules inspections in"
