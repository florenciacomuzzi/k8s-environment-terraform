terraform {
  required_version = ">= 1.3.0"
  # change to google
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.24.0"
    }
  }
}

# Configure the Linode Provider
# set google provider knowing that auth is handled by environment variable
# provider "linode" {
#   # token = var.token
# }
provider "google" {
  project = var.project_id
  region  = var.region
}