terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.5.0"
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

variable "zone" {
  description = "zone"
}


module "base" {
    source = "../base"

    project_id  = var.project_id
    region      = var.region
    zone        = var.zone
    environment = "dev"
}

// A variable for extracting the external IP address of the VM
output "Web-server-URL" {
 value = join("",["http://","${module.base.vm_ip}",":5000"])
}
