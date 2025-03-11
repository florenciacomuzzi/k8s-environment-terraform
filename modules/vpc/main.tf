# Create a VPC Network
resource "google_compute_network" "vpc" {
  name                     = var.network_name
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

# Create a Subnet for GKE with Secondary Ranges
resource "google_compute_subnetwork" "gke_subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
  region        = var.region

  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cluster_secondary_range_cidr
  }

  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.services_secondary_range_cidr
  }
}
