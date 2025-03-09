module "vpc" {
  source                        = "./modules/vpc"
  project_id                    = var.project_id
  region                        = var.region
  network_name                  = var.network_name
  subnet_cidr                   = var.subnet_cidr
  subnet_name                   = var.subnet_name
  cluster_secondary_range_name  = var.cluster_secondary_range_name
  cluster_secondary_range_cidr  = var.cluster_secondary_range_cidr
  services_secondary_range_name = var.services_secondary_range_name
  services_secondary_range_cidr = var.services_secondary_range_cidr
}


# Optional: Create a GKE Cluster
# resource "google_container_cluster" "gke_cluster" {
#   name               = "gke-cluster"
#   location           = "us-central1"
#   network            = var.network_name
#   subnetwork        = var.subnet_name
#   remove_default_node_pool = true
#
#   ip_allocation_policy {
#     cluster_secondary_range_name  = var.cluster_secondary_range_name
#     services_secondary_range_name = var.services_secondary_range_name
#   }
# }
#
# # Node pool for GKE Cluster
# resource "google_container_node_pool" "gke_nodes" {
#   name       = "gke-node-pool"
#   location   = "us-central1"
#   cluster    = google_container_cluster.gke_cluster.name
#   node_count = 3
#
#   node_config {
#     machine_type = "e2-standard-4"
#     disk_size_gb = 100
#     oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
#   }
# }
