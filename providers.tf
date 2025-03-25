terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  default_labels = {
    infrastructure = "crossing-the-narrow-bridge"
  }
  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "PROACTIVE"
}

provider "random" {}