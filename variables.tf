variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "credentials_file_path" {
  description = "Path to your service-account JSON key. If null, uses ADC."
  type        = string
  default     = null
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "my-vm"
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Boot disk size (GB)"
  type        = number
  default     = 20
}

variable "startup_script" {
  description = "Path to startup script"
  type        = string
  default     = "startup.sh"
}
