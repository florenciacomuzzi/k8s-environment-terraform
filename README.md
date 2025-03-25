# k8s-environment-terraform

This repository contains Terraform code to create a VPC and various types of Kubernetes clusters in 
an environment. This work is part of a take home assignment for a company during the interview process.
These modules were _tested_ in a GCP project created for this assignment. A budget of $100 was set. 
The `main` branch represents the production environment and is currently up. This repository works 
as a template and can be cloned.

* Refer to the [SETUP](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SETUP.md) 
for instructions on setting up your own project.
* For information on CICD, refer to the
[CICD](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SETUP.md) documentation.
* For information on how to contribute to your own project, refer to the
[SDLC](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SDLC.md) documentation.

---

## Assumptions
I have assumed the following:
* Unique modules are expected i.e. can't use existing module like 
[`terraform-google-kubernetes-engine/modules/private-cluster`](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v36.1.0/modules/beta-private-cluster).
* Modules are opinionated.
* Scale is unknown so sensibility of sample values is subjective.

---

## Networking
The network setup is unknown. In a real scenario, there is careful planning of IP address ranges for 
services, pods, and load balancers with each in its own subnet. The module creates a private cluster 
so the cluster's master node is only accessible within the VPC. A Default Deny VPC is an area for 
improvement.

---

## Security
* The GKE node pool service account is used by the nodes in the cluster to authenticate and interact 
with GCP services. Workloads can impersonate a different service account using Workload Identity thus
overriding the use of the node pool service account.
* The `private-k8s-cluster` module creates a jump host to connect to the cluster's master node as
the master node can only be accessed from within the VPC.
* A user authenticates with the jump host using Identity-Aware Proxy.
* By default, GKE deploys the ip-masq-agent with a configuration that selectively masquerades 
traffic—rewriting pod IPs for destinations that fall outside specified CIDRs. 

---

## Autoscaling
The following features are enabled by the gke module: 
* The cluster autoscaler in GKE is responsible for automatically adjusting the number of nodes 
in a node pool based on resource demands (like CPU and memory usage).
* Node Autoprovisioning is a feature of GKE's cluster autoscaler but works at a higher level than 
individual node pools. It allows the GKE cluster to dynamically create new node pools when the 
existing node pools cannot meet the resource needs of the workloads.
* Vertical Pod Autoscaling (VPA) is a feature that automatically 
adjusts the resource requests (CPU and memory) for individual Pods based on their actual usage over 
time. This helps ensure that each Pod has enough resources to operate efficiently without 
over-provisioning or under-provisioning resources.

---

## CICD
CICD runs in GitHub Actions. A unique service account is used by the pipeline to authenticate with 
GCP. A service account credentials file is used however Workload Identity Federation is preferred 
for authentication. This is a potential area for improvement. 

The actual Terraform state is stored in a Cloud Storage bucket. Terraform authenticates using the
CICD service account however best practice is for Terraform to impersonate a separate, distinct 
service account used by Terraform with just enough permissions to manage GCP resources.

For more information on setting up CICD, refer to the
[CICD](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SETUP.md) documentation.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.24.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.1 |

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
| <a name="input_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#input\_cluster\_secondary\_range\_name) | The name of the secondary range to use for pods | `string` | `"gke-pods"` | no |
| <a name="input_jump_host_ip_address"></a> [jump\_host\_ip\_address](#input\_jump\_host\_ip\_address) | The internal IP address of the jump host | `string` | n/a | yes |
| <a name="input_jump_host_ip_address_name"></a> [jump\_host\_ip\_address\_name](#input\_jump\_host\_ip\_address\_name) | Name of the IP address resource | `string` | `"jump-host-ip"` | no |
| <a name="input_jump_host_name"></a> [jump\_host\_name](#input\_jump\_host\_name) | The name of the jump host VM | `string` | `"jump-host"` | no |
| <a name="input_master_authorized_cidr_blocks"></a> [master\_authorized\_cidr\_blocks](#input\_master\_authorized\_cidr\_blocks) | The CIDR block allowed to connect to the master node | <pre>list(object({<br/>    cidr_block   = string<br/>    display_name = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_block": "10.0.0.7/32",<br/>    "display_name": "Network 1"<br/>  },<br/>  {<br/>    "cidr_block": "192.168.1.0/24",<br/>    "display_name": "Network 2"<br/>  }<br/>]</pre> | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The CIDR block for the master node | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network | `string` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | The node pools to create | <pre>list(object({<br/>    name                 = string<br/>    node_disk_size_gb    = string<br/>    node_machine_type    = string<br/>    total_min_node_count = number<br/>    total_max_node_count = number<br/>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | `"florenciacomuzzi"` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"us-east1"` | no |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | The name of the secondary range to use for services | `string` | `"gke-services"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->