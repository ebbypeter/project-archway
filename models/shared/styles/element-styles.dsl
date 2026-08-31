# Shared element styles — included inside the views block of the workspace.
#
# VISUAL LANGUAGE
#   Fill colour  = portfolio (Critical / Market / Enterprise / External)
#   Border       = hosting posture (dashed = vendor-hosted / outside our estate)
#   Thick stroke = business-critical system
#
# Fill is reserved for the portfolio so that colour means exactly one thing on
# every diagram. Classification tags therefore style the border, never the
# background: when two tags set the same attribute the element's tag order
# silently decides the winner, which is not something authors should have to
# reason about.

styles {

    element "Element" {
        color #ffffff
    }

    element "Person" {
        shape person
        background #3f4a56
    }

    # Fallback for anything without a portfolio (should not happen — the
    # validator requires exactly one portfolio tag per system).
    element "Software System" {
        background #8a94a0
    }

    element "Container" {
        background #6b7684
    }

    element "Component" {
        background #98a2b0
    }

    # --- Portfolios: the primary colour encoding -------------------------

    element "Critical Apps" {
        background #c05621
        color #ffffff
    }

    element "Market Apps" {
        background #1f5fa9
        color #ffffff
    }

    element "Enterprise Apps" {
        background #2f7d4f
        color #ffffff
    }

    element "External Apps" {
        background #6b7280
        color #ffffff
    }

    # --- Classifications: border only, so they compose with any portfolio ---

    element "CriticalSystem" {
        stroke #1a1a1a
        strokeWidth 6
    }

    element "VendorHosted" {
        border dashed
        stroke #1a1a1a
        strokeWidth 4
    }
}
