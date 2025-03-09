resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
  location           = var.region
  network            = var.network_name
  subnetwork        = var.subnet_name
  remove_default_node_pool = true

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
}

# Node pool for GKE Cluster
resource "google_container_node_pool" "gke_nodes" {
  name       = "gke-node-pool"
  location   = var.region
  cluster    = var.cluster_name
  node_count = 3

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 100
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}