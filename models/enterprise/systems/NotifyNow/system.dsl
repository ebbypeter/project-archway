notifyNow = softwareSystem "NotifyNow" {
    description "Notification platform for email, SMS and push messages."

    tags "EnterpriseSystem" "Platform" "SaaS" "VendorHosted"

    properties {
        owner "Corporate Services"
        capability "Corporate Services"
        lifecycle "Production"
        criticality "Medium"
        hosting "SaaS"
        vendor "NotifyNow Inc."
        supportTeam "Digital Workplace Team"
    }

    perspectives {
        "Technology" "Vendor SaaS"
        "Lifecycle" "Production"
        "Ownership" "Corporate Services"
        "Criticality" "Medium"
    }

    !docs docs
}
