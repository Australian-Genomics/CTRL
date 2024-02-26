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
