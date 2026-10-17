# Security Policies

* Workforce authentication is centralised on IdentityCloud — OIDC preferred,
  SAML 2.0 where the product requires it (see Security workspace ADR-0001).
* Every interface document states its data classification and authentication
  method.
* Secrets (API keys, client credentials) are never stored in this repository.
* Every in-house system publishes a CycloneDX SBOM for each release, generated
  by its build, in its `sbom/` folder. Vendor and SaaS systems record in their
  `sbom` property whether the vendor supplies one.
* Vendor-hosted and SaaS systems are tagged so trust boundaries are visible in
  the Security workspace.
