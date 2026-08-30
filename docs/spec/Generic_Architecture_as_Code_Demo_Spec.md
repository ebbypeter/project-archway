# Generic Architecture-as-Code Implementation Specification (Demo Edition)

## Purpose
This generic specification is designed for demonstrations, workshops, proof-of-concepts, and Architecture-as-Code training.

It intentionally uses fictional people, systems, integrations, platforms, and solutions so that audiences focus on the Architecture-as-Code approach rather than debating real systems.

Technology Stack:
- C4 Model
- Structurizr DSL
- AsciiDoc
- Git-based source control
- CI/CD Pipelines

---
# Fictional Enterprise

Company Name:

Apex Energy Corporation

Business Domains:
- Network Operations
- Asset Management
- Customer Services
- Data & Analytics
- Corporate Services

---
# Fictional Personas

## Operations Engineer
Operates the energy network.

## Asset Planner
Plans asset investments and maintenance.

## Data Analyst
Uses analytics platforms and reports.

## System Administrator
Administers enterprise platforms.

## Business Manager
Consumes dashboards and reports.

---
# Fictional Systems

## GridView
Operational network monitoring platform.

## AssetHub
Asset management platform.

## InsightLake
Enterprise analytics platform.

## IdentityCloud
Enterprise identity provider.

## ServiceDeskPro
IT service management platform.

## NotifyNow
Notification platform.

---
# Fictional Integrations

GridView -> InsightLake

AssetHub -> InsightLake

GridView -> IdentityCloud

AssetHub -> IdentityCloud

ServiceDeskPro -> NotifyNow

---
# Goals

Create a repository that:

- Defines systems once
- Defines people once
- Treats integrations as first-class assets
- Generates documentation
- Generates diagrams
- Generates inventory reports

---
# Repository Structure

```text
architecture-model/
├── models/
│   ├── enterprise/
│   ├── integrations/
│   ├── solutions/
│   └── shared/
├── workspaces/
├── docs/
├── scripts/
├── templates/
├── CODEOWNERS
└── README.md
```

---
# Enterprise Model

## People

models/enterprise/people/

Example:

```dsl
operationsEngineer = person "Operations Engineer"
assetPlanner = person "Asset Planner"
dataAnalyst = person "Data Analyst"
```

## Systems

models/enterprise/systems/

Example Structure:

```text
GridView/
  system.dsl

AssetHub/
  system.dsl

InsightLake/
  system.dsl
```

Example Definition:

```dsl
gridView = softwareSystem "GridView" {

    tags "EnterpriseSystem"

    properties {
        owner "Operations"
        capability "Network Operations"
        runtime ".NET 10"
        hosting "Cloud"
        lifecycle "Production"
        criticality "High"
    }
}
```

---
# Integration Assets

Location:

models/integrations/

Example:

```text
GridView-InsightLake/
├── relationship.dsl
├── docs/
└── adr/
```

relationship.dsl

```dsl
gridView -> insightLake "Publishes operational telemetry"
```

---
# Solution Assets

Example Solution:

Network Intelligence Program

```text
solutions/
└── NetworkIntelligence/
    ├── architecture/
    ├── views/
    ├── docs/
    └── adr/
```

Containers Example:

```dsl
networkPortal = container "Network Portal"
analyticsApi = container "Analytics API"
reportingDb = container "Reporting Database"
```

---
# Shared Assets

## Approved Tags

- EnterpriseSystem
- CriticalSystem
- Platform
- VendorHosted
- SaaS

## Styles Example

```dsl
element "CriticalSystem" {
    background #D32F2F
    color #FFFFFF
}
```

---
# Metadata Strategy

Technology metadata stored in properties.

Example:

```dsl
properties {
    runtime ".NET 10"
    database "PostgreSQL"
    hosting "Cloud"
}
```

Do not create technology tags.

---
# Workspaces

## Enterprise Workspace

Audience:
- Enterprise Architects
- Stakeholders

Views:
- Enterprise Landscape
- Portfolio Overview

## Technology Workspace

Audience:
- Technology Leadership

Views:
- Runtime Report
- Database Report
- Hosting Report

## Security Workspace

Audience:
- Security Architects

Views:
- Authentication Landscape
- Trust Boundaries

## Integration Workspace

Audience:
- Integration Architects

Views:
- Integration Diagram
- Data Flow Diagram

---
# Perspectives

Technology Perspective
- Runtime
- Database
- Hosting

Lifecycle Perspective
- Production
- Under Upgrade
- Retiring

Ownership Perspective
- Owner
- Support Team

Criticality Perspective
- High
- Medium
- Low

---
# Documentation

## Capabilities

Network Operations
Asset Management
Customer Services
Data & Analytics
Corporate Services

## Policies

Architecture
Integration
Security
Technology
Operations

---
# ADR Template

```text
ADR-001

Status
Context
Decision
Consequences
```

---
# Reporting Examples

Generate reports such as:

- Systems running .NET 10
- Systems running Java 21
- Systems hosted in Cloud
- Critical Systems
- Systems by Capability

---
# Demo Scenario

People:
- Operations Engineer
- Asset Planner
- Data Analyst

Systems:
- GridView
- AssetHub
- InsightLake
- IdentityCloud

Integrations:
- GridView -> InsightLake
- AssetHub -> InsightLake
- GridView -> IdentityCloud

Solutions:
- Network Intelligence Program
- Asset Modernization Program

Workspaces:
- Enterprise
- Technology
- Security
- Integration

This scenario should be used for demonstrations, workshops, training, and proof-of-concepts.
