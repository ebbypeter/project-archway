# Shared element styles — included inside the views block of each workspace.
# Keyed on approved tags only (see models/shared/tags/approved-tags.adoc).

styles {

    element "Element" {
        color #ffffff
    }

    element "Person" {
        shape person
        background #08427b
    }

    element "Software System" {
        background #1168bd
    }

    element "Container" {
        background #438dd5
    }

    element "Platform" {
        background #6a1b9a
    }

    element "SaaS" {
        background #00796b
    }

    element "VendorHosted" {
        border dashed
    }

    element "CriticalSystem" {
        background #d32f2f
    }
}
