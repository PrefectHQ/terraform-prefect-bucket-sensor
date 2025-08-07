data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventgrid_system_topic" "this" {
  count = var.create_eventgrid_system_topic ? 1 : 0

  name                   = "${var.storage_account_name}-storage-topic"
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = data.azurerm_storage_account.this.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

resource "azurerm_eventgrid_event_subscription" "this" {
  name  = "${var.storage_account_name}-prefect-event-subscription"
  scope = coalesce(var.eventgrid_system_topic_id, azurerm_eventgrid_system_topic.this[0].id)

  webhook_endpoint {
    url = prefect_webhook.this.endpoint
  }

  dynamic "delivery_property" {
    for_each = var.create_service_account ? [1] : []
    content {
      header_name = "Authorization"
      value       = "Bearer ${prefect_service_account.this[0].api_key}"
      type        = "Static"
      secret      = true
    }
  }

  retry_policy {
    max_delivery_attempts = var.max_delivery_attempts
    event_time_to_live    = var.event_time_to_live
  }

  advanced_filter {
    string_in {
      key    = "Data.eventType"
      values = var.eventgrid_subscription_event_type
    }
  }
}

# Read the Prefect account information from the provider
data "prefect_account" "this" {}
data "prefect_workspace" "this" {}
data "prefect_workspace_role" "this" {
  name = "Developer"
}

# Optional service account
resource "prefect_service_account" "this" {
  count = var.create_service_account == true ? 1 : 0
  name = "azure-${var.storage_account_name}-webhook"
  account_role_name = "Member"
}

resource "prefect_workspace_access" "this" {
  count = var.create_service_account == true ? 1 : 0
  accessor_type = "SERVICE_ACCOUNT"
  accessor_id = prefect_service_account.this[0].id
  workspace_id = data.prefect_workspace.this.id
  workspace_role_id = data.prefect_workspace_role.this.id
}

resource "prefect_webhook" "this" {
  name        = "azure-${var.storage_account_name}-bucket-sensor"
  description = "Receives events from Azure Storage Blob for ${var.storage_account_name} in ${var.resource_group_name}"
  enabled     = true
  template = jsonencode({
    event = "azure.storage.blob.created"
    resource = {
      "prefect.resource.id"   = "azure.storage.${var.storage_account_name}"
      "prefect.resource.name" = "Azure Storage Blob"
    }
    // https://docs.prefect.io/v3/automate/events/webhook-triggers#accepting-cloudevents
    data = "{{ body|from_cloud_event(headers) }}"
  })

  service_account_id = coalesce(var.service_account_id, prefect_service_account.this[0].id)
  workspace_id       = data.prefect_workspace.this.id
}
