gridView = softwareSystem "GridView" {
    description "Operational network monitoring platform for the energy network."

    tags "EnterpriseSystem" "CriticalSystem"

    properties {
        owner "Network Operations"
        capability "Network Operations"
        lifecycle "Production"
        criticality "High"
        runtime ".NET 10"
        database "PostgreSQL"
        hosting "Cloud"
        supportTeam "Network Operations Support"
    }

    perspectives {
        "Technology" ".NET 10 / PostgreSQL / Cloud"
        "Lifecycle" "Production"
        "Ownership" "Network Operations"
        "Criticality" "High"
    }

    !docs docs
}

operationsEngineer -> gridView "Monitors the energy network using"
systemAdministrator -> gridView "Administers"
