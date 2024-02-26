module "default-project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.4"

  project_id = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "artifactregistry.googleapis.com",
  ]

  disable_dependent_services  = true
  disable_services_on_destroy = false
}
