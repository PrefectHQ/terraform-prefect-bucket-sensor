<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_prefect"></a> [prefect](#provider\_prefect) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_api_destination.prefect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_api_destination) | resource |
| [aws_cloudwatch_event_connection.prefect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_connection) | resource |
| [aws_cloudwatch_event_rule.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.prefect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.eventbridge_invoke_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.eventbridge_invoke_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [prefect_webhook.webhook](https://registry.terraform.io/providers/hashicorp/prefect/latest/docs/resources/webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefect_webhook_url"></a> [prefect\_webhook\_url](#input\_prefect\_webhook\_url) | The URL of the Prefect webhook to send notifications to | `string` | n/a | yes |
| <a name="input_bucket_event_notification_types"></a> [bucket\_event\_notification\_types](#input\_bucket\_event\_notification\_types) | The types of S3 events to send notifications for | `list(string)` | <pre>[<br/>  "Object Created",<br/>  "Object Deleted"<br/>]</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create | `string` | `"s3-event-notification-bucket"` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the SNS topic to create | `string` | `"s3-event-notification-topic"` | no |
| <a name="input_webhook_name"></a> [webhook\_name](#input\_webhook\_name) | The name of the Prefect webhook | `string` | `"s3-webhook"` | no |
| <a name="input_webhook_template"></a> [webhook\_template](#input\_webhook\_template) | The template for the Prefect webhook payload. Defaults to a template for S3 events. | `map(any)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->