# Transpower Architecture-as-Code Specification v2.0

## Purpose
This specification defines the target-state Architecture-as-Code (AaC) capability for Transpower using:
- C4 Model
- Structurizr DSL
- AsciiDoc
- GitLab
- GitLab CI/CD

The repository is intended to become an enterprise architecture knowledge repository that supports:
- Solution Architecture
- Enterprise Architecture
- Architecture Governance (ARB/TAR)
- Technology Lifecycle Management
- System Integration Governance
- Architecture Documentation
- Architecture Decision Records (ADRs)

---

# Vision

Single source of truth for:
- People
- Enterprise Systems
- Integrations
- Solution Architectures
- Technology Metadata
- Architecture Decisions
- Architecture Documentation

Outputs:
- Interactive Structurizr Workspaces
- C4 Diagrams
- Architecture Portal
- Technology Reports
- Integration Catalog
- Documentation Portal

---
# Core Principles

## P1 Single Source of Truth
Every enterprise system is defined once.

## P2 Model First
The DSL model is authoritative.

## P3 Documentation as Code
Documentation resides in Git.

## P4 Integration First
Integrations are first-class architecture assets.

## P5 Federated Ownership
Enterprise owns canonical assets.
Solution teams own implementation details.

## P6 Properties over Technology Tags
Technology metadata is stored in properties.

Example:
```dsl
properties {
  runtime ".NET 10"
  database "SQL Server 2022"
  hosting "Azure"
}
```

---
# Repository Structure

```text
transpower-architecture-model/
├── models/
│   ├── enterprise/
│   ├── integrations/
│   ├── solutions/
│   └── shared/
├── workspaces/
├── docs/
├── .gitlab-ci.yml
├── CODEOWNERS
└── README.md
```

---
# Enterprise Model

## People

Location:
```text
models/enterprise/people/
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
Snowflake/
  system.dsl
```

System template:
```dsl
tees = softwareSystem "TEES" {

  tags "EnterpriseSystem"

  properties {
    owner "Asset Information"
    capability "Asset Management"
    runtime ".NET 10"
    database "SQL Server 2022"
    hosting "Azure"
    lifecycle "Production"
    criticality "High"
  }
}
```

Required properties:
- owner
- capability
- lifecycle
- criticality

Optional properties:
- runtime
- database
- hosting
- vendor
- supportTeam
- repository

---
# Integration Model

Location:
```text
models/integrations/
```

Example:
```text
TEES-Snowflake/
├── relationship.dsl
├── docs/
└── adr/
```

Template:
```dsl
tees -> snowflake "Publishes asset data"
```

Documentation should cover:
- Interface purpose
- Authentication
- Protocol
- Data classification
- Operational ownership
- Support model

---
# Solution Model

Location:
```text
models/solutions/
```

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

Containers Example:
```dsl
powertech = softwareSystem "Powertech Tools" {

  vsat = container "VSAT"
  tsat = container "TSAT"
  dsaManager = container "DSA Manager"
}
```

Deployment Example:
```dsl
deploymentEnvironment "Production" {

  deploymentNode "Windows Server 2025" {
      containerInstance vsat
  }
}
```

---
# Shared Assets

Location:
```text
models/shared/
```

## Tags

Approved tags:
- EnterpriseSystem
- OTSystem
- Platform
- VendorHosted
- CriticalSystem
- SaaS

## Styles

Example:
```dsl
element "OTSystem" {
  background #D32F2F
  color #FFFFFF
}
```

## Archetypes

Provide reusable patterns:
- API
- Database
- Vendor Application
- SaaS Application

---
# Workspaces

Purpose:
Consumer-focused views over the shared model.

Structure:
```text
workspaces/
├── Enterprise/
├── Operations/
├── Security/
├── Technology/
└── Integration/
```

## Enterprise Workspace

Audience:
- Enterprise Architects
- ARB
- Leadership

Views:
- Enterprise Landscape
- Capability Mapping
- System Portfolio

## Operations Workspace

Audience:
- Operations Teams

Views:
- SCADA Dependencies
- EMS Dependencies
- Powertech Landscape

## Security Workspace

Audience:
- Security Architects

Views:
- Authentication Landscape
- Identity Dependencies
- Trust Boundaries

## Technology Workspace

Audience:
- Architects
- Lifecycle Managers

Views:
- Runtime Analysis
- Database Analysis
- Hosting Analysis

## Integration Workspace

Audience:
- Integration Architects

Views:
- Integration Landscape
- Data Flow View
- Interface Portfolio

Workspace Example:
```dsl
workspace "Technology Viewpoint" {

  !include ../../models/enterprise/**/*.dsl
  !include ../../models/integrations/**/*.dsl
}
```

---
# Documentation Structure

```text
docs/
├── architecture-as-code/
├── capabilities/
└── policies/
```

## architecture-as-code

Contains:
- Repository structure
- Contribution guide
- Naming standards
- DSL conventions
- Review process

## capabilities

Examples:
- Grid Operations
- Asset Management
- Planning
- Data & Analytics
- Market Operations

These are documentation artifacts, not model elements.

## policies

### architecture
- ADR standard
- Diagram standard
- Documentation standard

### integration
- API standards
- Event standards
- SaaS integration patterns

### security
- Authentication
- Authorization
- Logging
- Encryption

### technology
- Approved technologies
- Technology lifecycle

### operations
- DR
- Backup
- Monitoring

---
# DSL Standards

## Naming

Systems:
```text
TEES
SCADA
Snowflake
Powertech
```

Avoid:
```text
TEES PROD
TEES SYSTEM
SNOWFLAKE PROD
```

## Relationships

Preferred verbs:
- Uses
- Publishes Data
- Consumes Data
- Authenticates Via
- Monitors
- Administers

Avoid vague verbs.

---
# ADR Standard

Structure:
```text
ADR-001

Status
Context
Decision
Consequences
```

---
# GitLab Governance

## CODEOWNERS

```text
models/shared/*
  Architecture Practice

models/enterprise/systems/*
  Architecture Practice + System Owner

models/integrations/*
  Integration Owner

models/solutions/*
  Solution Architect
```

## Merge Requests

All changes through MR.

Mandatory reviews:
- Enterprise Assets
- Shared Assets
- Integration Assets

---
# GitLab CI/CD

Stages:
```text
validate
render
publish
```

Validation:
- Compile DSL
- Validate mandatory properties
- Validate approved tags
- Validate naming standards

Outputs:
- Structurizr Workspaces
- Documentation Site
- Inventory Reports

---
# Inventory Reporting Roadmap

Future reporting from properties:
- Systems using .NET 8
- Systems using .NET 10
- Systems using SQL Server 2019
- Systems hosted in Azure
- Vendor Hosted Systems
- Critical Systems
- Systems by Capability

---
# Bootstrap Pilot

Model initially:

Systems:
- TEES
- Snowflake
- Powertech
- Entra ID
- SCADA

Integrations:
- TEES-Snowflake
- TEES-EntraID
- SCADA-VSAT

Workspaces:
- Enterprise
- Technology
- Integration
- Security

Success Criteria:
- DSL compiles
- Documentation generated
- Governance model validated
- ARB/TAR usability confirmed
