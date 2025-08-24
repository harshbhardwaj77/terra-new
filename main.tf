terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  # If you provide a path in var.credentials_file_path, read the JSON contents.
  credentials = var.credentials_file_path == null ? null : file(var.credentials_file_path)
}

# Enable Compute API
resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# Simple VM with HTTP/HTTPS tags (relies on existing firewall rules that target these tags)
resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  # Mirrors Console behavior: tags used by default firewall rules
  tags = ["ssh", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network = "default"
    access_config {} # ephemeral external IP
  }

  # Provide a startup script file path via var.startup_script
  metadata_startup_script = file(var.startup_script)

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [google_project_service.compute]
}

output "vm_external_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
