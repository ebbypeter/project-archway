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

        !include ../../models/shared/styles/element-styles.dsl
        !include ../../models/shared/styles/relationship-styles.dsl
    }
}
