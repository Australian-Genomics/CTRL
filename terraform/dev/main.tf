terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.0.0"
    }
  }
  backend "gcs" {
    bucket = "ctrl-tf-remote-state"
    prefix = "dev"
  }
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

module "base" {
    source = "../base"

    project_id = var.project_id
    region     = var.region
}
