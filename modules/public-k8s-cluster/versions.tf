terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.29.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
}
