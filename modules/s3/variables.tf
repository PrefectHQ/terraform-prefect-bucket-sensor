variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
  default     = "s3-event-notification-bucket"
}

# https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventBridge.html
variable "bucket_event_notification_types" {
  type        = list(string)
  description = "The types of S3 events to send notifications for"
  default     = ["Object Created", "Object Deleted"]
}

variable "topic_name" {
  type        = string
  description = "The name of the SNS topic to create"
  default     = "s3-event-notification-topic"
}

variable "prefect_webhook_url" {
  type        = string
  description = "The URL of the Prefect webhook to send notifications to"
}
