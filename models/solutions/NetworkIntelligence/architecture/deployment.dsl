# Production deployment of the Network Intelligence solution.
# Deployment nodes and container instances — rendered by the deployment view
# in the Enterprise workspace.

deploymentEnvironment "Production" {

    deploymentNode "Apex Cloud" "Primary cloud region." "Apex Cloud Platform" {

        deploymentNode "Kubernetes Cluster" "Managed Kubernetes service." "Kubernetes 1.33" {

            deploymentNode "Portal Deployment" "3 replicas behind the ingress." "Node.js 24 container" {
                containerInstance networkPortal
            }

            deploymentNode "API Deployment" "3 replicas, horizontal pod autoscaling." ".NET 10 container" {
                containerInstance analyticsApi
            }
        }

        deploymentNode "Managed PostgreSQL" "Cloud database service, zone-redundant." "PostgreSQL 17" {
            containerInstance reportingDb
        }
    }
}
