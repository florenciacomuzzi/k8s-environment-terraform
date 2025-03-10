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
  source                        = "./modules/public-k8s-cluster"
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
  depends_on                    = [module.vpc]
}
