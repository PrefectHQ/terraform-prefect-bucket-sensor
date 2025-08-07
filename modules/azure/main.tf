data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventgrid_system_topic" "this" {
  count = var.create_eventgrid_system_topic ? 1 : 0

  name                   = coalesce(var.eventgrid_system_topic_name_override, "${var.storage_account_name}-storage-topic")
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = data.azurerm_storage_account.this.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

resource "azurerm_eventgrid_event_subscription" "this" {
  name  = coalesce(var.eventgrid_event_subscription_name_override, "${var.storage_account_name}-prefect-event-subscription")
  scope = try(azurerm_eventgrid_system_topic.this[0].id, var.eventgrid_system_topic_id, null)

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

  lifecycle {
    precondition {
      condition = var.create_eventgrid_system_topic == true || (var.create_eventgrid_system_topic == false && var.eventgrid_system_topic_id != null)
      error_message = "eventgrid_system_topic_id must be defined when create_eventgrid_system_topic = false"
    }
  }
}

# Read the Prefect account information from the provider
data "prefect_account" "this" {}
data "prefect_workspace" "this" {}
data "prefect_workspace_role" "this" {
  name = var.prefect_service_account_workspace_role_name
}

# Optional service account
resource "prefect_service_account" "this" {
  count = var.create_service_account == true ? 1 : 0
  name = coalesce(var.prefect_service_account_name_override, "azure-${var.storage_account_name}-webhook")
  account_role_name = var.prefect_service_account_role_name
}

resource "prefect_workspace_access" "this" {
  count = var.create_service_account == true ? 1 : 0
  accessor_type = "SERVICE_ACCOUNT"
  accessor_id = prefect_service_account.this[0].id
  workspace_id = data.prefect_workspace.this.id
  workspace_role_id = data.prefect_workspace_role.this.id
}

resource "prefect_webhook" "this" {
  name        = coalesce(var.prefect_webhook_name_override, "azure-${var.storage_account_name}-bucket-sensor")
  description = coalesce(var.prefect_webhook_description_override, "Receives events from Azure Storage Blob for ${var.storage_account_name} in ${var.resource_group_name}")
  enabled     = var.prefect_webhook_enabled
  template    = var.prefect_webhook_template_override != null ? jsonencode(var.prefect_webhook_template_override) : jsonencode({
      event = "azure.storage.blob.created"
      resource = {
        "prefect.resource.id"   = "azure.storage.${var.storage_account_name}"
        "prefect.resource.name" = "Azure Storage Blob"
      }
      data = var.prefect_webhook_template_data
    })

  service_account_id = try(prefect_service_account.this[0].id, var.prefect_service_account_id, null)
}
