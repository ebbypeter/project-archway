group "Enterprise Apps" {
    serviceDeskPro = softwareSystem "ServiceDeskPro" {
        description "IT service management platform for incidents, requests and changes."

        tags "EnterpriseSystem" "Enterprise Apps" "SaaS" "VendorHosted"

        properties {
            owner "Corporate Services"
            capability "Corporate Services"
            lifecycle "Production"
            criticality "Medium"
            hosting "SaaS"
            vendor "ServiceDeskPro Ltd."
            supportTeam "IT Service Management Team"

            sbom "Not available: SaaS; vendor does not publish an SBOM"
        }

        perspectives {
            "Technology" "Vendor SaaS"
            "Lifecycle" "Production"
            "Ownership" "Corporate Services"
            "Criticality" "Medium"
        }

        !docs docs
    }
}

systemAdministrator -> serviceDeskPro "Manages incidents and changes in"
