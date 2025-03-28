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
  default     = "10.20.0.0/16"
  description = "The secondary range to use for pods"
}

variable "services_secondary_range_cidr" {
  type        = string
  default     = "10.30.0.0/16"
  description = "The name of the secondary range to use for services"
}
