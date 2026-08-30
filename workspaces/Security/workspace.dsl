workspace "Apex Energy — Security" "Authentication landscape and identity dependency views for Security Architects." {

    !docs docs
    !adrs adrs

    model {
        !include ../../models/model.dsl
    }

    views {

        properties {
            "generatr.site.exporter" "structurizr"
        }

        systemContext identityCloud "AuthenticationLandscape" "Every system and person that depends on IdentityCloud for authentication." {
            include *
            autoLayout lr
        }

        systemLandscape "TrustLandscape" "Full landscape; vendor-hosted and SaaS systems are dashed/coloured per the shared styles." {
            include *
            autoLayout lr
        }

        # Tag-scoped view: only the external trust surface. (Structurizr also has
        # `filtered` views, but the site generator does not render those, so we
        # scope a real view with an element expression instead.)
        systemLandscape "VendorHostedSystems" "Only vendor-hosted and SaaS systems — the external trust surface." {
            include "element.tag==VendorHosted || element.tag==SaaS"
            autoLayout lr
        }

        !include ../../models/shared/styles/element-styles.dsl
        !include ../../models/shared/styles/relationship-styles.dsl
    }
}
