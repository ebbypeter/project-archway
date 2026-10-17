## Apex Energy — Architecture

The Enterprise Architecture Knowledge Repository of Apex Energy Corporation,
generated from a single Structurizr model in Git. All content — diagrams,
documentation, decisions and inventories — is produced from source control;
nothing here is hand-drawn.

### Finding your way

* **Software Systems** — every enterprise system and solution, each with its
  context, container, component and deployment views, documentation and
  dependencies. Views are defined in the model next to the elements they show.
* **Enterprise Landscape** — the whole estate on one page.
* **Portfolio landscapes** (generated) — one page per portfolio: its systems,
  the systems in other portfolios they connect to, and those connections.
* **Trust Views** — the external (vendor-hosted / SaaS) trust surface, for
  security review.
* **Integration Views** and the generated **Interface Catalogue** — every
  system-to-system interface as a first-class, documented asset.
* **Component Inventory** (generated) — SBOM coverage per system and every
  library across the estate, with the systems that use it.
* **Technology Inventory** (generated) — the estate by runtime, database,
  hosting, lifecycle and criticality, built from model properties.
* **Architecture Practice Standards**, **Policies** and **Business Capabilities** —
  published from the repository's `docs/` folder.
* **Decisions** — architecture decision records.

All changes are made via merge request; see the Contribution Guide under
Architecture Practice Standards.
