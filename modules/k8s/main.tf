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
  node_count = 3

  node_config {
    machine_type    = "e2-standard-2"
    disk_size_gb    = 100
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.default.email
  }
  depends_on = [google_container_cluster.gke_cluster]
  lifecycle {
    ignore_changes = [node_config]
  }
}