<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_google"></a> [google](#requirement\_google) | < 8 |
| <a name="requirement_prefect"></a> [prefect](#requirement\_prefect) | >= 2.13.5, < 3 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | < 8 |
| <a name="provider_prefect"></a> [prefect](#provider\_prefect) | >= 2.13.5, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_pubsub_subscription.subscription](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_topic.topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_binding) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_notification.notification](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification) | resource |
| [prefect_webhook.webhook](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/webhook) | resource |
| [google_storage_project_service_account.gcs_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_project_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket_event_notification_types"></a> [bucket\_event\_notification\_types](#input\_bucket\_event\_notification\_types) | The types of GCS events to send notifications for. See [documentation](https://cloud.google.com/storage/docs/pubsub-notifications#supported_event_types) for supported event types | `list(string)` | <pre>[<br/>  "OBJECT_FINALIZE",<br/>  "OBJECT_METADATA_UPDATE"<br/>]</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the GCS bucket to create | `string` | `"gcs-event-notification-bucket"` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the PubSub topic to create | `string` | `"gcs-event-notification-topic"` | no |
| <a name="input_webhook_name"></a> [webhook\_name](#input\_webhook\_name) | The name of the Prefect webhook | `string` | `"gcs-webhook"` | no |
| <a name="input_webhook_template"></a> [webhook\_template](#input\_webhook\_template) | The template for the Prefect webhook payload. Defaults to a template for GCS events | `any` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_webhook"></a> [webhook](#output\_webhook) | The Prefect webhook resource. Use the metadata to get the endpoint or webhook ID for downstream Automations |
<!-- END_TF_DOCS -->