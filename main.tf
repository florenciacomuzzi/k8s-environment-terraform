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

module "gke" {
  source                        = "./modules/private-k8s-cluster"
  project_id                    = var.project_id
  region                        = var.region
  network_name                  = var.network_name
  subnet_name                   = var.subnet_name
  cluster_name                  = var.cluster_name
  cluster_secondary_range_name  = var.cluster_secondary_range_name
  services_secondary_range_name = var.services_secondary_range_name
  node_machine_type             = var.node_machine_type
  node_count                    = var.node_count
  node_disk_size_gb             = var.node_disk_size_gb
  max_pods_per_node             = var.max_pods_per_node
  authorized_cidr_block         = var.authorized_cidr_block
  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
  depends_on                    = [module.vpc]
}
