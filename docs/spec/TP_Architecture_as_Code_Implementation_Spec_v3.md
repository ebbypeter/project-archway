# Transpower Architecture-as-Code Implementation Specification (v3.0)

## Status
Proposed Architecture Practice Standard

## Objective
This specification is intended to be executable by GitHub Copilot, Copilot Coding Agent, Claude Code, or similar AI development agents to generate the initial repository structure, templates, CI/CD pipelines, Structurizr DSL assets, governance rules, and documentation framework.

---
# 1. Target Architecture

Architecture-as-Code Platform Components:

1. Structurizr DSL (authoritative architecture model)
2. C4 Model (visualisation standard)
3. AsciiDoc (documentation)
4. GitLab (source control + governance)
5. GitLab CI/CD (validation and publishing)
6. Architecture Portal (published output)

Principle:

Single Architecture Model
    -> Workspaces
    -> Diagrams
    -> Documentation
    -> ADRs
    -> Inventory Reports

---
# 2. Repository Layout

```text
transpower-architecture-model/
├── models/
│   ├── enterprise/
│   ├── integrations/
│   ├── solutions/
│   └── shared/
├── workspaces/
├── docs/
├── scripts/
├── templates/
├── .gitlab-ci.yml
├── CODEOWNERS
└── README.md
```

---
# 3. Enterprise Assets

## People

Location:

models/enterprise/people/

Files:

operations.dsl
asset-management.dsl
planning.dsl
analytics.dsl
corporate.dsl

Example:

```dsl
operationsEngineer = person "Operations Engineer"
assetEngineer = person "Asset Engineer"
planningEngineer = person "Planning Engineer"
```

Rules:
- Canonical definitions only.
- No duplicate person definitions elsewhere.

## Systems

Location:

models/enterprise/systems/

Pattern:

```text
<SystemName>/
├── system.dsl
└── docs/
```

Example:

```dsl
tees = softwareSystem "TEES" {

    tags "EnterpriseSystem"

    properties {
        owner "Asset Information"
        capability "Asset Management"
        lifecycle "Production"
        criticality "High"
        runtime ".NET 10"
        database "SQL Server 2022"
        hosting "Azure"
    }
}
```

Mandatory Properties:

- owner
- capability
- lifecycle
- criticality

Optional Properties:

- runtime
- runtimeVersion
- database
- hosting
- supportTeam
- vendor
- repository
- businessOwner

---
# 4. Integration Assets

Location:

models/integrations/

Pattern:

```text
<SystemA-SystemB>/
├── relationship.dsl
├── docs/
└── adr/
```

Example:

```dsl
tees -> snowflake "Publishes asset data"
```

Integration Documentation Must Include:

- Purpose
- Source System
- Target System
- Data Classification
- Authentication Method
- Transport Protocol
- Support Team
- Operational Ownership
- Monitoring Approach

---
# 5. Solution Assets

Location:

models/solutions/

Structure:

```text
Powertech/
├── architecture/
│   ├── containers.dsl
│   ├── components.dsl
│   └── deployment.dsl
├── views/
├── docs/
└── adr/
```

Ownership:

Solution Architect

Contains:

- Containers
- Components
- Deployment Nodes
- Solution Views
- Solution ADRs

---
# 6. Shared Assets

Location:

models/shared/

## Tags

Approved Tags:

- EnterpriseSystem
- OTSystem
- Platform
- SaaS
- VendorHosted
- CriticalSystem
- InternalSystem
- ExternalSystem

## Styles

Files:

```text
styles/
├── element-styles.dsl
├── relationship-styles.dsl
└── themes.dsl
```

## Archetypes

Files:

```text
archetypes/
├── api.dsl
├── database.dsl
├── vendor-system.dsl
└── saas-application.dsl
```

---
# 7. Metadata Standard

Technology data SHALL be stored using properties.

Example:

```dsl
properties {
    runtime ".NET 10"
    database "SQL Server 2022"
    hosting "Azure"
}
```

Technology versions SHALL NOT be represented as tags.

Incorrect:

```dsl
tags "DotNet10"
```

Reason:
Prevents duplicated information.

---
# 8. Workspace Strategy

Workspaces are consumer-facing viewpoints.

Location:

workspaces/

## Enterprise Workspace

Audience:
- Enterprise Architects
- ARB
- Leadership

Views:
- Enterprise Landscape
- Portfolio Overview

## Operations Workspace

Audience:
- Operations Teams

Views:
- SCADA Dependency View
- EMS Dependency View

## Security Workspace

Views:
- Authentication Landscape
- Identity Dependencies

## Technology Workspace

Views:
- Technology Inventory
- Runtime Analysis
- Database Analysis

## Integration Workspace

Views:
- Enterprise Integration Landscape
- Interface Catalogue

Example Workspace:

```dsl
workspace "Technology Workspace" {

    !include ../../models/enterprise/**/*.dsl
    !include ../../models/integrations/**/*.dsl

}
```

---
# 9. Perspective Strategy

Perspectives overlay metadata.

Required Perspectives:

## Technology Perspective

Displays:
- runtime
- database
- hosting

## Lifecycle Perspective

Displays:
- lifecycle

Values:
- Production
- Under Upgrade
- Legacy
- Retiring

## Ownership Perspective

Displays:
- owner
- supportTeam

## Criticality Perspective

Displays:
- criticality

Values:
- High
- Medium
- Low

## Security Perspective

Displays:
- classification
- authentication

---
# 10. Documentation Standards

Location:

docs/

## architecture-as-code

Required Documents:

- repository-structure.adoc
- modelling-standards.adoc
- naming-standards.adoc
- contribution-guide.adoc
- workspace-guidelines.adoc

## capabilities

Business capability documentation:

- Grid Operations
- Asset Management
- Planning
- Data & Analytics
- Market Operations
- Enterprise Operations

## policies

Architecture
Integration
Security
Data
Technology
Operations

---
# 11. ADR Standard

Template:

```text
ADR-001

Status
Context
Decision
Consequences
References
```

Statuses:

- Proposed
- Accepted
- Superseded
- Retired

---
# 12. Naming Standards

Systems:

Valid:
- TEES
- SCADA
- Snowflake

Invalid:
- TEES PROD
- SCADA SYSTEM

Relationships:

Preferred:
- Uses
- Publishes Data
- Consumes Data
- Authenticates Via
- Monitors
- Administers

---
# 13. GitLab Governance

## CODEOWNERS

models/shared/*
Architecture Practice

models/enterprise/systems/*
Architecture Practice + System Owner

models/integrations/*
Integration Owner

models/solutions/*
Solution Architect

## Merge Requests

Required for all changes.

---
# 14. GitLab CI/CD

Stages:

1. validate
2. render
3. publish

Validate:

- DSL compilation
- Mandatory property validation
- Approved tag validation
- Duplicate system validation

Render:

- Structurizr export
- Documentation generation

Publish:

- Architecture portal
- Documentation site

---
# 15. Reporting Framework

Future reports derived from properties:

- Systems by Runtime
- Systems by Database
- Systems by Hosting Platform
- Systems by Capability
- Systems by Criticality
- Systems by Lifecycle

Examples:

Show all systems running:
- .NET 8
- .NET 10
- Java 21
- SQL Server 2019

---
# 16. Bootstrap Content Required

Generate examples for:

Enterprise Systems:
- TEES
- Snowflake
- SCADA
- Powertech
- Entra ID

Integrations:
- TEES-Snowflake
- TEES-EntraID
- SCADA-VSAT

Workspaces:
- Enterprise
- Technology
- Security
- Integration

Documentation:
- ADR templates
- AsciiDoc templates
- Capability templates
- Policy templates

---
# 17. Success Criteria

Repository is considered successful when:

1. Enterprise systems are defined once.
2. Integrations are reusable assets.
3. Workspaces generate without manual edits.
4. Architecture documents are generated from source control.
5. Technology inventory reporting is possible from metadata.
6. ARB/TAR consumers can navigate architecture through published workspaces.
