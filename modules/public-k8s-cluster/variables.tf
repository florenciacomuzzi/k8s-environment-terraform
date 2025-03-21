variable "project_id" {
  type        = string
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

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_disk_size_gb" {
  type        = number
  default     = 10 # "100" requires quota increase
  description = "The size of the disk attached to each node, in GB"
}

variable "node_machine_type" {
  type        = string
  default     = "e2-standard-2"
  description = "The type of machine to create for each node"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "The number of nodes to create"
}

variable "max_pods_per_node" {
  type        = number
  default     = 32
  description = "The maximum number of pods to schedule on each node"
}