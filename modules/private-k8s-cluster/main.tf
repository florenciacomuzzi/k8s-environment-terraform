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
    cidr_blocks {
      cidr_block   = var.authorized_cidr_block
      display_name = "net1"
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