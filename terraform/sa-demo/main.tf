terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.5.0"
    }
  }
  backend "gcs" {
    bucket = "ctrl-tf-remote-state"
    prefix = "sa-demo"
  }
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}


module "base" {
    source = "../base"

    project_id  = var.project_id
    region      = var.region
    zone        = var.zone
    environment = "sa-demo"
}
