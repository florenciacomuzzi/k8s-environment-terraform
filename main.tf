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
  source                            = "./modules/private-k8s-cluster"
  project_id                        = var.project_id
  region                            = var.region
  network_name                      = var.network_name
  subnet_name                       = var.subnet_name
  cluster_name                      = var.cluster_name
  cluster_secondary_range_name      = var.cluster_secondary_range_name
  services_secondary_range_name     = var.services_secondary_range_name
  master_authorized_cidr_blocks     = var.master_authorized_cidr_blocks
  master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  subnet_cidr                       = var.subnet_cidr
  cluster_secondary_range_cidr      = var.cluster_secondary_range_cidr
  cluster_autoscaling_max_memory_gb = var.cluster_autoscaling_max_memory_gb
  cluster_autoscaling_max_cpu       = var.cluster_autoscaling_max_cpu
  node_pools                        = var.node_pools
  jump_host_name                    = var.jump_host_name
  jump_host_ip_address_name         = var.jump_host_ip_address_name
  jump_host_ip_address              = var.jump_host_ip_address
  depends_on                        = [module.vpc]
}
