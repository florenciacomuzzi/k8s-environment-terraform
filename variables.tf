variable "project_id" {
  type        = string
  default     = "florenciacomuzzi"
  description = "GCP project id"
}

variable "region" {
  type        = string
  default     = "us-east1"
  description = "GCP region"
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "cluster_secondary_range_name" {
  type        = string
  default     = "gke-pods"
  description = "The name of the secondary range to use for pods"
}

variable "services_secondary_range_name" {
  type        = string
  default     = "gke-services"
  description = "The name of the secondary range to use for services"
}

variable "cluster_secondary_range_cidr" {
  type        = string
  description = "The secondary range to use for pods"
}

variable "services_secondary_range_cidr" {
  type        = string
  default     = "10.30.0.0/16"
  description = "The secondary range to use for services"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_pool_name" {
  type        = string
  description = "The name of the cluster node pool"
}

variable "node_disk_size_gb" {
  type        = number
  default     = "100"
  description = "The size of the disk attached to each node, in GB"
}

variable "node_machine_type" {
  type        = string
  default     = "e2-standard-2"
  description = "The type of machine to create for each node"
}

variable "total_min_node_count" {
  type        = number
  default     = 1
  description = "The minimum number of nodes to create"
}

variable "total_max_node_count" {
  type        = number
  default     = 3
  description = "The maximum number of nodes to create"
}

variable "master_authorized_cidr_blocks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "10.0.0.7/32"
      display_name = "Network 1"
    },
    {
      cidr_block   = "192.168.1.0/24"
      display_name = "Network 2"
    }
  ]
  description = "The CIDR block allowed to connect to the master node"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The CIDR block for the master node"
}

variable "cluster_autoscaling_max_memory_gb" {
  type        = string
  default     = "32"
  description = "The maximum memory for the cluster autoscaler and used across all node pools"
}

variable "cluster_autoscaling_max_cpu" {
  type        = string
  default     = "8"
  description = "The maximum CPU for the cluster autoscaler and used across all node pools"
}

variable "jump_host_ip_address" {
  type        = string
  description = "The internal IP address of the jump host"
}

variable "create_jump_host" {
  type        = bool
  default     = true
  description = "Whether to create jump host"
}