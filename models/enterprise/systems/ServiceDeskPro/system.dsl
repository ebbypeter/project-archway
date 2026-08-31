group "Corporate Apps" {
    serviceDeskPro = softwareSystem "ServiceDeskPro" {
        description "IT service management platform for incidents, requests and changes."

        tags "EnterpriseSystem" "Corporate Apps" "SaaS" "VendorHosted"

        properties {
            owner "Corporate Services"
            capability "Corporate Services"
            lifecycle "Production"
            criticality "Medium"
            hosting "SaaS"
            vendor "ServiceDeskPro Ltd."
            supportTeam "IT Service Management Team"
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
