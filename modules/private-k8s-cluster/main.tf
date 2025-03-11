resource "random_string" "identifier" {
  length           = 5
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "123456789"
}

resource "google_service_account" "default" {
  account_id   = "k8s-sa-${random_string.identifier.result}"
  display_name = "Node pool service account"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:k8s-sa-${random_string.identifier.result}@${var.project_id}.iam.gserviceaccount.com"
}


resource "google_container_cluster" "gke_cluster" {
  name       = var.cluster_name
  location   = var.region
  network    = var.network_name
  subnetwork = var.subnet_name

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

# Node pool for GKE Cluster
resource "google_container_node_pool" "gke_nodes" {
  name       = "gke-node-pool"
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.node_count

  max_pods_per_node = var.max_pods_per_node

  node_config {
    machine_type    = var.node_machine_type
    disk_size_gb    = var.node_disk_size_gb
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.default.email
  }

  depends_on = [google_container_cluster.gke_cluster]
  lifecycle {
    ignore_changes = [node_config]
  }
}

# Create jump host to access private k8s cluster

resource "google_compute_address" "my_internal_ip_addr" {
  project      = var.project_id
  address_type = "INTERNAL"
  region       = var.region
  subnetwork   = var.subnet_name
  name         = "my-ip"
  address      = "10.0.0.7"
  description  = "An internal IP address for jump host"
}

resource "google_compute_instance" "default" {
  project      = var.project_id
  zone         = "${var.region}-b"
  name         = "jump-host"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name # Replace with a reference or self link to your subnet, in quotes
    network_ip = google_compute_address.my_internal_ip_addr.address
  }
}


## Creare Firewall to access jump hist via iap
resource "google_compute_firewall" "rules" {
  project = var.project_id
  name    = "allow-ssh"
  network = var.network_name # Replace with a reference or self link to your network, in quotes

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}



## Create IAP SSH permissions for your test instance

resource "google_project_iam_member" "project" {
  project = "tcb-project-371706"
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:terraform-demo-aft@tcb-project-371706.iam.gserviceaccount.com"
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = "tcb-project-371706"
  name    = "nat-router"
  network = "vpc1"
  region  = "asia-south2"
}

## Create Nat Gateway with module

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = "tcb-project-371706"
  region     = "asia-south2"
  router     = google_compute_router.router.name
  name       = "nat-config"

}