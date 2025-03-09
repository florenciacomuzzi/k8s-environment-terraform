<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.gke_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#input\_cluster\_secondary\_range\_name) | The name of the secondary range to use for pods | `string` | `"gke-pods"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"us-east1"` | no |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | The name of the secondary range to use for services | `string` | `"gke-services"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->