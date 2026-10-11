# Transpower Architecture-as-Code Specification (v1.0)

## Purpose
This document defines the target Architecture-as-Code (AaC) approach for Transpower using:
- C4 Model
- Structurizr DSL
- AsciiDoc
- GitLab

The repository is intended to become an Enterprise Architecture Knowledge Repository rather than a diagram repository.

---

# 1. Architecture Principles

## Principle 1: Single Source of Truth
Architectural entities are defined once and reused.

Examples:
- TEES
- SCADA
- EMS
- Snowflake
- Entra ID
- Operations Engineer
- Asset Engineer

No duplicate definitions are permitted.

## Principle 2: Model First
The Structurizr model is the authoritative source.

Generated outputs:
- Diagrams
- Architecture portals
- Documentation
- Inventories
- Dependency maps

## Principle 3: Federated Ownership
Enterprise Architecture owns:
- People
- Systems
- Tags
- Styles
- Archetypes

Integration owners own:
- Integrations
- Interface documentation
- Integration ADRs

Solution architects own:
- Containers
- Components
- Deployment architecture
- Solution documentation
- Solution ADRs

## Principle 4: Integration-as-an-Asset
Integrations are first-class assets.

Examples:
- TEES-Snowflake
- SCADA-VSAT
- TEES-EntraID

Integrations shall not be owned by either source or target systems.

## Principle 5: Properties are Facts
Use Structurizr properties for metadata.

Examples:
- runtime
- database
- owner
- supportTeam
- hosting
- lifecycle
- criticality

Example:

```dsl
properties {
    owner "Asset Information"
    runtime ".NET 8"
    database "SQL Server 2022"
    hosting "Azure"
    lifecycle "Production"
}
```

## Principle 6: Tags are Classifications
Tags are not used for technology versions.

Good tags:
- EnterpriseSystem
- OTSystem
- Platform
- CriticalSystem
- VendorHosted
- SaaS

Bad tags:
- DotNet8
- Java21
- SQL2019

---

# 2. Repository Structure

```text
transpower-architecture-model/
|
|-- models/
|   |-- enterprise/
|   |   |-- people/
|   |   `-- systems/
|   |
|   |-- integrations/
|   |
|   |-- solutions/
|   |
|   `-- shared/
|       |-- tags/
|       |-- styles/
|       |-- archetypes/
|       `-- constants/
|
|-- workspaces/
|
|-- docs/
|   |-- architecture-as-code/
|   |-- policies/
|   `-- capabilities/
|
|-- .gitlab-ci.yml
|-- CODEOWNERS
`-- README.md
```

---

# 3. Enterprise Model

## People
Location:

```text
models/enterprise/people/
```

Example files:

```text
operations.dsl
asset-management.dsl
planning.dsl
analytics.dsl
```

Example:

```dsl
operationsEngineer = person "Operations Engineer"
assetEngineer = person "Asset Engineer"
```

## Systems
Location:

```text
models/enterprise/systems/
```

Structure:

```text
TEES/
    system.dsl
    docs/

SCADA/
    system.dsl
    docs/
```

Example:

```dsl
tees = softwareSystem "TEES" {

    tags "EnterpriseSystem"

    properties {
        owner "Asset Information"
        capability "Asset Management"
        runtime ".NET 8"
        database "SQL Server 2022"
        hosting "Azure"
        lifecycle "Production"
        criticality "High"
    }
}
```

---

# 4. Integration Asset Model

Location:

```text
models/integrations/
```

Example:

```text
TEES-Snowflake/
    relationship.dsl
    docs/
    adr/
```

Example relationship:

```dsl
tees -> snowflake "Publishes asset data"
```

Integration folders may contain:
- Authentication design
- Network paths
- Data contracts
- Operational ownership
- ADRs

---

# 5. Solution Model

Location:

```text
models/solutions/
```

Example:

```text
Powertech/
    architecture/
        containers.dsl
        components.dsl
        deployment.dsl

    views/

    docs/

    adr/
```

Solution folders own:
- Containers
- Components
- Deployment
- Views
- ADRs

---

# 6. Shared Model Assets

Location:

```text
models/shared/
```

## Tags

```text
EnterpriseSystem
OTSystem
Platform
CriticalSystem
VendorHosted
SaaS
```

## Styles

Centralized styling rules.

Example:

```dsl
element "OTSystem" {
    background #D32F2F
    color #FFFFFF
}
```

## Archetypes

Reusable patterns.

Examples:
- API
- Database
- SaaS Application
- Vendor System

---

# 7. Workspaces

Workspaces are consumer-facing views.

Location:

```text
workspaces/
```

Examples:

```text
Enterprise/
Operations/
Security/
Technology/
Integration/
```

Workspaces consume models.

They do not define systems.

## Technology Workspace Example

```dsl
workspace "Technology Viewpoint" {

    !include ../../models/enterprise/**/*.dsl

}
```

Technology information is sourced from system properties.

---

# 8. Documentation Structure

Location:

```text
docs/
```

## Architecture-as-Code

Contains:
- Repository standards
- Naming conventions
- Contribution guide
- Workspace guidelines

## Policies

Contains:

### Architecture
- ADR standard
- Documentation standard

### Integration
- API standards
- Integration patterns

### Security
- Authentication
- Authorization
- Logging
- Encryption

### Data
- Classification
- Retention

### Technology
- Technology lifecycle
- Approved technologies

### Operations
- Backup
- Monitoring
- Disaster recovery

## Capabilities

Business capability descriptions.

Examples:
- Grid Operations
- Asset Management
- Planning
- Data & Analytics
- Market Operations

Capabilities are documentation, not Structurizr assets.

---

# 9. GitLab Governance

## CODEOWNERS

Recommended ownership:

```text
models/enterprise/people/*
    Architecture Practice

models/shared/*
    Architecture Practice

models/enterprise/systems/*
    System Owner + Architecture Practice

models/integrations/*
    Integration Owner

models/solutions/*
    Solution Architect
```

## Merge Requests

All changes shall be performed via Merge Requests.

---

# 10. GitLab CI/CD

Pipeline stages:

```text
validate
build
publish
```

Validation rules:
- Required properties exist
- Approved tags only
- Naming standards enforced
- Duplicate systems detected
- DSL compiles successfully

Generated outputs:
- Structurizr workspaces
- Static architecture portal
- Technology inventory reports
- Integration catalogue
- Documentation site

---

# 11. Initial Pilot Scope

Start with:

Systems:
- TEES
- Powertech
- Snowflake
- Entra ID

Integrations:
- TEES-Snowflake
- TEES-EntraID
- SCADA-VSAT

Workspaces:
- Enterprise
- Technology
- Integration

This pilot should validate repository conventions before enterprise-wide rollout.
