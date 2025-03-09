module "gke_public" {
  source     = "terraform-google-modules/kubernetes-engine/google"
  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region
  network    = module.vpc.network_name
  subnetwork = module.vpc.subnet_name

  ip_range_pods     = "gke-pods"
  ip_range_services = "gke-services"

  # enable_private_nodes     = false # Public cluster
  # enable_private_endpoint  = false # Public API endpoint
  # enable_ip_masq_agent     = true
  remove_default_node_pool = true

  node_pools = [
    {
      name         = "default-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 3
      disk_size_gb = 50
      autoscaling  = true
    }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = var.network_name
  subnets = [
    {
      subnet_name   = var.subnet_name
      subnet_ip     = var.subnet_cidr
      subnet_region = var.region
    }
  ]
}
