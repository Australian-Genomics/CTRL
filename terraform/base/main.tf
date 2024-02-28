terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.5.0"
    }
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

variable "zone" {
  description = "zone"
}

variable "environment" {
  description = "env"
}

resource "google_compute_network" "vpc_network" {
  name                    = "ctrl-${var.environment}-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "ctrl-${var.environment}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

data "cloudinit_config" "conf" {
  gzip = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = file("cloud-init.yaml")
    filename = "cloud-init.yaml"
  }
}

# read rails master.key from secret manager
data "google_secret_manager_secret_version" "ctrl-master-key" {
 secret   = "ctrl-master-key"
}


# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = "ctrl-tf-${var.environment}-server"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size = 50
    }
  }

  metadata = {
    user-data = "${data.cloudinit_config.conf.rendered}"
  }

  metadata_startup_script = <<EOT
    echo RAILS_MASTER_KEY=${data.google_secret_manager_secret_version.ctrl-master-key.secret_data} >> /etc/profile &&
    echo DEPLOY_ENV=${var.environment} >> /etc/profile"
    EOT

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

resource "google_compute_firewall" "ssh" {
  name = "ctrl-${var.environment}-allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "caddy" {
  name    = "ctrl-${var.environment}-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "vm_ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

resource "google_dns_record_set" "ctrl" {
  managed_zone = "dsp"

  name    = "ctrl-${var.environment}.dsp.garvan.org.au."
  type    = "A"
  rrdatas = ["${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"]
  ttl     = 300
}
