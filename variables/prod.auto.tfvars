project_id                    = "florenciacomuzzi"
region                        = "us-east1"
network_name                  = "florenciacomuzzi-vpc-prod"
cluster_name                  = "florenciacomuzzi-cluster-prod"
subnet_cidr                   = "10.0.0.0/24"
subnet_name                   = "my-subnet"
cluster_secondary_range_name  = "gke-pods"
cluster_secondary_range_cidr  = "10.11.0.0/21"
services_secondary_range_name = "gke-services"
services_secondary_range_cidr = "10.12.0.0/21"
master_ipv4_cidr_block        = "10.13.0.0/28"
master_authorized_cidr_blocks = [
  {
    cidr_block   = "10.0.0.7/32"
    display_name = "net1"
  }
]
cluster_autoscaling_max_memory_gb = 30
cluster_autoscaling_max_cpu       = 16
node_pools = [
  {
    name                 = "gke-node-pool"
    node_disk_size_gb    = 10
    node_machine_type    = "e2-standard-2"
    total_min_node_count = 1
    total_max_node_count = 3
  }
]
jump_host_ip_address = "10.0.0.7"
create_jump_host     = true
