# Terraform set up for CTRL

### `initial-terraform-setup`

Code to set up remote back end for ctrl (this only needs to be run once during project initation)

### `workload-identidy-federation-setup`

Code to set up gcp apis, workload identity federation infrastructure and service accounts to enable github actions to interact with GCP.

### `base`

Core infra that is common to all deployment environments. This can be configured by variables.

### `dev`

Configuration for dev deployments.
