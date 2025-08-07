<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 4 |
| <a name="requirement_prefect"></a> [prefect](#requirement\_prefect) | >= 2.13.5, < 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_prefect"></a> [prefect](#provider\_prefect) | >= 2.13.5, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_eventgrid_event_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_event_subscription) | resource |
| [azurerm_eventgrid_system_topic.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic) | resource |
| [prefect_service_account.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/service_account) | resource |
| [prefect_webhook.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/webhook) | resource |
| [prefect_workspace_access.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/workspace_access) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [prefect_account.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/account) | data source |
| [prefect_workspace.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/workspace) | data source |
| [prefect_workspace_role.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/workspace_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_eventgrid_system_topic"></a> [create\_eventgrid\_system\_topic](#input\_create\_eventgrid\_system\_topic) | Should a new Event Grid System Topic be created for this Storage Account? | `bool` | `true` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Creates a new developer role service account in the workspace for webhook authentication. | `bool` | `false` | no |
| <a name="input_event_time_to_live"></a> [event\_time\_to\_live](#input\_event\_time\_to\_live) | n/a | `number` | `1440` | no |
| <a name="input_eventgrid_subscription_event_type"></a> [eventgrid\_subscription\_event\_type](#input\_eventgrid\_subscription\_event\_type) | n/a | `list(string)` | <pre>[<br/>  "Microsoft.Storage.BlobCreated"<br/>]</pre> | no |
| <a name="input_eventgrid_system_topic_id"></a> [eventgrid\_system\_topic\_id](#input\_eventgrid\_system\_topic\_id) | The ID of an existing Event Grid System Topic for a Storage Account. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the Event Grid System Topic should exist. | `string` | n/a | yes |
| <a name="input_max_delivery_attempts"></a> [max\_delivery\_attempts](#input\_max\_delivery\_attempts) | n/a | `number` | `5` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure Resource Group Name | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Provide the ID of an existing service account in the workspace for webhook authentication. | `string` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The Storage Account Name to monitor | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventgrid_subscription_id"></a> [eventgrid\_subscription\_id](#output\_eventgrid\_subscription\_id) | n/a |
| <a name="output_eventgrid_system_topic_id"></a> [eventgrid\_system\_topic\_id](#output\_eventgrid\_system\_topic\_id) | n/a |
| <a name="output_prefect_service_account_id"></a> [prefect\_service\_account\_id](#output\_prefect\_service\_account\_id) | n/a |
| <a name="output_prefect_webhook_id"></a> [prefect\_webhook\_id](#output\_prefect\_webhook\_id) | n/a |
<!-- END_TF_DOCS -->