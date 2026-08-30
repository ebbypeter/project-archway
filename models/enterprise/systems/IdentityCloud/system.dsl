identityCloud = softwareSystem "IdentityCloud" {
    description "Enterprise identity provider for authentication and single sign-on."

    tags "EnterpriseSystem" "CriticalSystem" "SaaS" "VendorHosted"

    properties {
        owner "Corporate Services"
        capability "Corporate Services"
        lifecycle "Production"
        criticality "High"
        hosting "SaaS"
        vendor "IdentityCloud Ltd."
        supportTeam "Identity & Access Team"
    }

    perspectives {
        "Technology" "Vendor SaaS"
        "Lifecycle" "Production"
        "Ownership" "Corporate Services"
        "Criticality" "High"
    }

    !docs docs
}

systemAdministrator -> identityCloud "Manages identities and access policies in"
