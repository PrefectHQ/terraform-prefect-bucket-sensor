variable "resource_group_name" {
  type = string
  description = "The Azure Resource Group Name"
}

variable "storage_account_name" {
  type = string
  description = "The Storage Account Name to monitor"
}

variable "location" {
  type = string
  description = "The Azure Region where the Event Grid System Topic should exist."
}

variable "create_eventgrid_system_topic" {
  type = bool
  default = true
  description = "Should a new Event Grid System Topic be created for this Storage Account?"
}

variable "eventgrid_system_topic_id" {
  type = string
  default = null
  description = "The ID of an existing Event Grid System Topic for a Storage Account."
}

variable "create_service_account" {
  type = bool
  default = false
  description = "Creates a new developer role service account in the workspace for webhook authentication."
}

variable "service_account_id" {
  type = string
  default = null
  description = "Provide the ID of an existing service account in the workspace for webhook authentication."
}

variable "max_delivery_attempts" {
  type = number
  default = 5
}

variable "event_time_to_live" {
  type = number
  default = 1440
}

variable "eventgrid_subscription_event_type" {
  type = list(string)
  default = ["Microsoft.Storage.BlobCreated"]
}
