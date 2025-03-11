project_id                    = "florenciacomuzzi"
region                        = "us-east1"
network_name                  = "florenciacomuzzi-vpc-dev"
cluster_name                  = "florenciacomuzzi-cluster-dev"
subnet_cidr                   = "10.10.0.0/16"
subnet_name                   = "my-subnet"
cluster_secondary_range_name  = "gke-pods"
cluster_secondary_range_cidr  = "192.168.0.0/21"
services_secondary_range_name = "gke-services"
services_secondary_range_cidr = "192.168.8.0/22"
node_disk_size_gb             = 50
node_machine_type             = "e2-standard-2"
node_count                    = 1
total_min_node_count          = 1
total_max_node_count          = 3
master_ipv4_cidr_block        = "10.13.0.0/28"
master_authorized_cidr_blocks = [
  {
    cidr_block   = "10.0.0.7/32"
    display_name = "Network 1"
  },
  {
    cidr_block   = "192.168.1.0/24"
    display_name = "Network 2"
  }
]