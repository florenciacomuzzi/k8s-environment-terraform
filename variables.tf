# variable "token" {
#   sensitive   = true
#   type        = string
#   description = "Linode API Token"
# }

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

variable "vpc_name" {
  type        = string
  description = "VPC network name"
}