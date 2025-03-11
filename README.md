<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
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
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_cluster_secondary_range_cidr"></a> [cluster\_secondary\_range\_cidr](#input\_cluster\_secondary\_range\_cidr) | The secondary range to use for pods | `string` | n/a | yes |
| <a name="input_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#input\_cluster\_secondary\_range\_name) | The name of the secondary range to use for pods | `string` | `"gke-pods"` | no |
| <a name="input_master_authorized_cidr_blocks"></a> [master\_authorized\_cidr\_blocks](#input\_master\_authorized\_cidr\_blocks) | The CIDR block allowed to connect to the master node | <pre>list(object({<br/>    cidr_block   = string<br/>    display_name = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_block": "10.0.0.7/32",<br/>    "display_name": "Network 1"<br/>  },<br/>  {<br/>    "cidr_block": "192.168.1.0/24",<br/>    "display_name": "Network 2"<br/>  }<br/>]</pre> | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The CIDR block for the master node | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network | `string` | n/a | yes |
| <a name="input_node_disk_size_gb"></a> [node\_disk\_size\_gb](#input\_node\_disk\_size\_gb) | The size of the disk attached to each node, in GB | `number` | `"100"` | no |
| <a name="input_node_machine_type"></a> [node\_machine\_type](#input\_node\_machine\_type) | The type of machine to create for each node | `string` | `"e2-standard-2"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | `"florenciacomuzzi"` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"us-east1"` | no |
| <a name="input_services_secondary_range_cidr"></a> [services\_secondary\_range\_cidr](#input\_services\_secondary\_range\_cidr) | The secondary range to use for services | `string` | `"10.30.0.0/16"` | no |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | The name of the secondary range to use for services | `string` | `"gke-services"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet | `string` | n/a | yes |
| <a name="input_total_max_node_count"></a> [total\_max\_node\_count](#input\_total\_max\_node\_count) | The maximum number of nodes to create | `number` | `3` | no |
| <a name="input_total_min_node_count"></a> [total\_min\_node\_count](#input\_total\_min\_node\_count) | The minimum number of nodes to create | `number` | `1` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->