project_id                    = "florenciacomuzzi"
region                        = "us-east1"
network_name                  = "florenciacomuzzi-vpc-prod"
cluster_name                  = "florenciacomuzzi-cluster-prod"
subnet_cidr                   = "10.10.0.0/16"
subnet_name                   = "my-subnet"
cluster_secondary_range_name  = "gke-pods"
cluster_secondary_range_cidr  = "10.11.0.0/21"
services_secondary_range_name = "gke-services"
services_secondary_range_cidr = "10.12.0.0/21"
node_disk_size_gb             = 50
node_machine_type             = "e2-standard-2"
node_count                    = 1
max_pods_per_node             = 32
master_ipv4_cidr_block        = "10.13.0.0/28"
master_authorized_cidr_blocks = [
  {
    cidr_block   = "10.0.0.7/32"
    display_name = "net1"
  }
]