# Components of the Analytics API.
# This file is included inside the analyticsApi container block in containers.dsl.

insightController = component "Insight Controller" "REST endpoints for insight and dashboard queries." "ASP.NET Core MVC"
insightService = component "Insight Service" "Aggregation, caching and authorisation logic for analytics queries." ".NET 10"
martRepository = component "Mart Repository" "Data access to the pre-aggregated reporting marts." "EF Core"
lakeGateway = component "InsightLake Gateway" "Runs federated queries against curated InsightLake datasets." ".NET 10 / ADO.NET"

# Component relationships
insightController -> insightService "Delegates queries to"
insightService -> martRepository "Reads aggregates via"
insightService -> lakeGateway "Runs federated queries via"
martRepository -> reportingDb "Reads from and writes to" "SQL"
lakeGateway -> insightLake "Executes queries against" "HTTPS/SQL"
networkPortal -> insightController "Calls" "HTTPS/JSON"
