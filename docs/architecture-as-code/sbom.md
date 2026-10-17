# Software Bills of Materials

Each system and solution stores the software bill of materials (SBOM) for what
it ships: the libraries and packages inside it, with versions and licences.
The portal publishes them so anyone can answer "what is inside this system?"
and "which systems use this library?" without asking each team.

## Where SBOMs live

One CycloneDX JSON file per deployable, in an `sbom/` folder in the asset's
own folder, named after the model element it describes:

| Asset | Path |
|---|---|
| Enterprise system | `models/enterprise/systems/<Name>/sbom/<systemIdentifier>.cdx.json` |
| Solution, one deployable | `models/solutions/<Name>/sbom/<systemIdentifier>.cdx.json` |
| Solution with several containers | `models/solutions/<Name>/sbom/<containerIdentifier>.cdx.json`, one per container |

For example, Asset Modernization ships two deployables, so it has
`fieldApp.cdx.json` and `assetSyncService.cdx.json`. The file name is what
ties an SBOM to the model; `make validate` rejects a name that is not the
system's identifier or one of its containers'.

## Producing an SBOM

Generate it from the build, never by hand. Any tool that writes CycloneDX
JSON works, for example:

```bash
syft <image-or-directory> -o cyclonedx-json > sbom/assetSyncService.cdx.json
```

```bash
cdxgen -t java -o sbom/assetSyncService.cdx.json
```

The best arrangement is for the system's release pipeline to do this on every
release and open a merge request here with the new file; CODEOWNERS routes it
to the system's owners. An SBOM copied in by hand once goes stale.

## Systems without an SBOM

Vendor and SaaS products often do not publish one. Record why in the system's
`sbom` property instead of leaving it blank:

```
sbom "Not available: SaaS; vendor does not publish an SBOM"
```

## Checks

`make validate`:

* **fails** on a file that is not valid CycloneDX JSON, is not named after the
  system or one of its containers, or sits outside a system or solution's
  `sbom/` folder;
* **warns** about an SBOM older than 90 days (from its `metadata.timestamp`),
  and about a system with neither an SBOM nor an `sbom` property.

## In the portal

* Each system with SBOMs gets a **Software Bill of Materials** page under its
  *Documentation* tab, listing every component.
* The **Component Inventory** (generated) shows SBOM coverage for every system
  and every component across the estate with the systems that use it. The
  portal search finds both, so searching for a library name shows where it is
  used.

The portal shows what is inside each system, not whether any of it has known
vulnerabilities — that changes daily and belongs in a tool that re-scans
continuously, such as Dependency-Track, fed from the same SBOM files.
