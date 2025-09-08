variable "resource_group_name" {
  type        = string
  description = "The Azure Resource Group Name"
}

variable "storage_account_name" {
  type        = string
  description = "The Storage Account Name to monitor"
}

variable "location" {
  type        = string
  description = "The Azure Region where the Event Grid System Topic should exist."
}

variable "create_eventgrid_system_topic" {
  type        = bool
  default     = true
  description = "Should a new Event Grid System Topic be created for this Storage Account?"
}

variable "eventgrid_system_topic_id" {
  type        = string
  default     = null
  description = "The ID of an existing Event Grid System Topic for a Storage Account."
}

variable "create_service_account" {
  type        = bool
  default     = false
  description = "Creates a new developer role service account in the workspace for webhook authentication."
}

variable "prefect_service_account_role_name" {
  type        = string
  default     = "Member"
  description = "The role the service account should be assigned in the account."
}

variable "prefect_service_account_workspace_role_name" {
  type        = string
  default     = "Developer"
  description = "The role the service account should be assigned in the workspace."
}

variable "prefect_service_account_id" {
  type        = string
  default     = null
  description = "Provide the ID of an existing service account in the workspace for webhook authentication."
}

variable "max_delivery_attempts" {
  type        = number
  default     = 5
  description = "The maximum number of times the Event Grid webhook will attempt to deliver the event."
}

variable "event_time_to_live" {
  type        = number
  default     = 1440
  description = "The maximum Event Grid webhook time to live"
}

variable "eventgrid_subscription_event_type" {
  type        = list(string)
  default     = ["Microsoft.Storage.BlobCreated"]
  description = "The Event Grid subscription type."
}

variable "eventgrid_system_topic_name_override" {
  type        = string
  default     = null
  description = "Overrides the generated name of the Azure System Topic resource."
}

variable "eventgrid_event_subscription_name_override" {
  type        = string
  default     = null
  description = "Overrides the generated name of the Azure Event Grid Event Subscription resource."
}

variable "prefect_service_account_name_override" {
  type        = string
  default     = null
  description = "Overrides the generated name of the Prefect Service Account resource."
}

variable "prefect_webhook_name_override" {
  type        = string
  default     = null
  description = "Overrides the generated name of the Prefect Webhook resource."
}

variable "prefect_webhook_description_override" {
  type        = string
  default     = null
  description = "Overrides the generated description of the Prefect Webhook resource."
}

variable "prefect_webhook_template_data" {
  type        = string
  default     = "{{ body|from_cloud_event(headers) }}"
  description = "The template to parse the webhook payload. (see https://docs.prefect.io/v3/automate/events/webhook-triggers#accepting-cloudevents for more details)"
}

variable "prefect_webhook_template_override" {
  type        = map(any) #TODO: better type, this must be any to keep properties from being dropped
  default     = null
  description = "Overrides the default template of the Prefect Webhook resource."
}

variable "prefect_webhook_enabled" {
  type        = bool
  default     = true
  description = "Status of the webhook"
}
