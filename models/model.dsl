# Canonical model include manifest.
#
# Every workspace includes the model via this single file, which guarantees a
# deterministic, dependency-safe ordering: definitions (people, systems) load
# before references (solutions, integrations).
#
# Rule: every model fragment under models/ (except shared/styles, which is
# included by workspace views) MUST be listed here. The validation pipeline
# fails if a .dsl file is missing from this manifest.

# --- People (canonical definitions) ---
!include enterprise/people/analytics.dsl
!include enterprise/people/asset-management.dsl
!include enterprise/people/corporate.dsl
!include enterprise/people/operations.dsl

# --- Enterprise systems (canonical definitions) ---
!include enterprise/systems/AssetHub/system.dsl
!include enterprise/systems/GridView/system.dsl
!include enterprise/systems/IdentityCloud/system.dsl
!include enterprise/systems/InsightLake/system.dsl
!include enterprise/systems/NotifyNow/system.dsl
!include enterprise/systems/ServiceDeskPro/system.dsl

# --- Solutions (containers, solution-level relationships) ---
!include solutions/AssetModernization/architecture/containers.dsl
!include solutions/NetworkIntelligence/architecture/containers.dsl

# --- Integrations (first-class relationship assets) ---
!include integrations/AssetHub-IdentityCloud/relationship.dsl
!include integrations/AssetHub-InsightLake/relationship.dsl
!include integrations/GridView-IdentityCloud/relationship.dsl
!include integrations/GridView-InsightLake/relationship.dsl
!include integrations/ServiceDeskPro-NotifyNow/relationship.dsl
