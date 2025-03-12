# k8s-environment-terraform
This repository contains Terraform code to create a VPC and various types of Kubernetes clusters in 
an environment. This work is part of a take home assignment for a company during the interview process.

* Refer to the [SETUP](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SETUP.md) 
for instructions on setting up your own project.
* For information on CICD, refer to the
[CICD](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SDLC.md) documentation.

---

## Assumptions
I have assumed the following:
* A unique root module is expected i.e. can't use existing module like 
[`terraform-google-kubernetes-engine/modules/private-cluster`](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v36.1.0/modules/beta-private-cluster).
* Modules are opinionated.
* Scale is unknown so sensibility of sample values is subjective.

---

## Testing
These modules were _tested_ in a GCP project created for this assignment. A budget of $100 was set. 
The `main` branch represents the production environment and is currently up.

---

## Networking
The network setup is unknown. In a real scenario, there is careful planning of IP address ranges for 
services, pods, and load balancers.

---

## Security
The `private-k8s-cluster` module creates a jump host to connect to the cluster's master node.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.24.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | ./modules/private-k8s-cluster | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_autoscaling_max_cpu"></a> [cluster\_autoscaling\_max\_cpu](#input\_cluster\_autoscaling\_max\_cpu) | The maximum CPU usage across all node pools to trigger the cluster autoscaler to provision more node pools | `string` | `"8"` | no |
| <a name="input_cluster_autoscaling_max_memory_gb"></a> [cluster\_autoscaling\_max\_memory\_gb](#input\_cluster\_autoscaling\_max\_memory\_gb) | The maximum memory usage across all node pools to trigger the cluster autoscaler to provision more node pools | `string` | `"32"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_cluster_secondary_range_cidr"></a> [cluster\_secondary\_range\_cidr](#input\_cluster\_secondary\_range\_cidr) | The secondary range to use for pods | `string` | n/a | yes |
| <a name="input_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#input\_cluster\_secondary\_range\_name) | The name of the secondary range to use for pods | `string` | `"gke-pods"` | no |
| <a name="input_jump_host_ip_address"></a> [jump\_host\_ip\_address](#input\_jump\_host\_ip\_address) | The internal IP address of the jump host | `string` | n/a | yes |
| <a name="input_master_authorized_cidr_blocks"></a> [master\_authorized\_cidr\_blocks](#input\_master\_authorized\_cidr\_blocks) | The CIDR block allowed to connect to the master node | <pre>list(object({<br/>    cidr_block   = string<br/>    display_name = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_block": "10.0.0.7/32",<br/>    "display_name": "Network 1"<br/>  },<br/>  {<br/>    "cidr_block": "192.168.1.0/24",<br/>    "display_name": "Network 2"<br/>  }<br/>]</pre> | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The CIDR block for the master node | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network | `string` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | The node pools to create | <pre>list(object({<br/>    name                 = string<br/>    node_disk_size_gb    = string<br/>    node_machine_type    = string<br/>    total_min_node_count = number<br/>    total_max_node_count = number<br/>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | `"florenciacomuzzi"` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"us-east1"` | no |
| <a name="input_services_secondary_range_cidr"></a> [services\_secondary\_range\_cidr](#input\_services\_secondary\_range\_cidr) | The secondary range to use for services | `string` | `"10.30.0.0/16"` | no |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | The name of the secondary range to use for services | `string` | `"gke-services"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->