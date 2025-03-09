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

# Firewall rules for GKE communication
resource "google_compute_firewall" "allow-internal" {
  name    = "gke-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr]
}

# Firewall rule to allow health checks
resource "google_compute_firewall" "allow-health-checks" {
  name    = "gke-allow-health-checks"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["10256", "15017"] # Common ports for health checks
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"] # Google Cloud health check IPs
}
