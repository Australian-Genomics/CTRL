terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.0.0"
    }
  }
  backend "gcs" {
    bucket = "ctrl-tf-remote-state"
    prefix = "project-setup"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

resource "google_artifact_registry_repository" "container-images-repo" {
  location = var.region
  repository_id = "ctrl-container-images"
  format = "DOCKER"
}

# Service accont and workload identity pool / provider for allowing GitHub Actions
# to interact with GCP Artifact Registry (for pushing and pulling docker images) 

# Service account associated with workload identity pool
resource "google_service_account" "github-svc" {
  project      = var.project_id
  account_id   = "gcp-github-access"
  display_name = "Service Account - github-svc"
}

resource "google_project_iam_member" "github-access" {

  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github-svc.email}"
}

resource "google_project_service" "wif_api" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ])

  service            = each.value
  disable_on_destroy = false
}

module "gh_oidc" {
  source            = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version           = "v3.1.2"
  project_id        = var.project_id
  pool_id           = "ctrl-gh-identity-pool"
  pool_display_name = "GitHub Identity Pool"
  provider_id       = "ctrl-gh-provider"
  sa_mapping = {
    (google_service_account.github-svc.account_id) = {
      sa_name   = google_service_account.github-svc.name
      attribute = "*"
    }
  }
}
