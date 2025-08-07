mock_provider "azurerm" {
  override_data {
    target = data.azurerm_storage_account.this
    values = {
      id = "/tenants/00000000-0000-0000-0000-000000000000/providers/Microsoft.Management/managementGroups/mock"
    }
  }
}

mock_provider "prefect" {
  override_data {
    target = data.prefect_account.this
    values = {
      id = "00000000-0000-0000-0000-000000000000"
    }
  }

  override_data {
    target = data.prefect_workspace.this
    values = {
      id = "00000000-0000-0000-0000-000000000000"
    }
  }

  override_data {
    target = data.prefect_workspace_role.this
    values = {
      id = "00000000-0000-0000-0000-000000000000"
    }
  }

  mock_resource "prefect_webhook" {
    defaults = {
      endpoint = "https://api.prefect.cloud/hooks/mocked"
    }
  }

  mock_resource "prefect_service_account" {
    defaults = {
      id = "00000000-0000-0000-0000-000000000000"
    }
  }
}

variables {
  location             = "us-east"
  resource_group_name  = "mock"
  storage_account_name = "mock"
}

run "ensure_defaults" {
  assert {
    condition     = try(prefect_service_account.this[0], null) == null
    error_message = "Prefect service account should not be created by default."
  }

  assert {
    condition = try(azurerm_eventgrid_system_topic.this[0], null) != null
    error_message = "Azure Event Grid system topic should be created by default."
  }

  assert {
    condition = azurerm_eventgrid_system_topic.this[0].name == "mock-storage-topic"
    error_message = "The system topic should be named \"${var.storage_account_name}-storage-topic\"."
  }

  assert {
    condition = azurerm_eventgrid_event_subscription.this.name == "mock-prefect-event-subscription"
    error_message = "The event subscription should be named \"${var.storage_account_name}-prefect-event-subscription\"."
  }

  assert {
    condition = prefect_webhook.this.service_account_id == null
    error_message = "The service_account_id for the prefect_webhook resource should be null."
  }

  assert {
    condition = prefect_webhook.this.template == jsonencode({
      event = "azure.storage.blob.created"
      resource = {
        "prefect.resource.id"   = "azure.storage.${var.storage_account_name}"
        "prefect.resource.name" = "Azure Storage Blob"
      }
      data = var.prefect_webhook_template_data
    })
    error_message = "The webhook template must use the correct default"
  }
}

run "ensure_creates_service_account" {
  variables {
    create_service_account = true
  }

  assert {
    condition     = try(prefect_service_account.this[0], null) != null
    error_message = "Service account should be created when create_service_account = true"
  }

  assert {
    condition = prefect_service_account.this[0].name == "azure-mock-webhook"
    error_message = "The service account should be named \"azure-${var.storage_account_name}-webhook\"."
  }

  assert {
    condition = try(azurerm_eventgrid_event_subscription.this.delivery_property[0].value) == "Bearer ${prefect_service_account.this[0].api_key}"
    error_message = "Event grid webhook delivery property should be set and the value should match the Bearer + API key of the Prefect service account."
  }

  assert {
    condition = prefect_webhook.this.service_account_id == "00000000-0000-0000-0000-000000000000"
    error_message = "The service_account_id for the prefect_webhook should be defined when create_service_account = true."
  }
}

run "ensure_doesnt_create_service_account" {
  variables {
    create_service_account = false
  }

  assert {
    condition     = try(prefect_service_account.this[0], null) == null
    error_message = "Service account resource should not be created when create_service_account = false"
  }

  assert {
    condition = try(azurerm_eventgrid_event_subscription.this.delivery_property[0], null) == null
    error_message = "The delivery property should not be defined."
  }
}

run "ensure_uses_defined_service_account_id" {
  variables {
    create_service_account = false
    prefect_service_account_id = "00000000-0000-0000-0000-000000000001"
  }

  assert {
    condition = prefect_webhook.this.service_account_id == "00000000-0000-0000-0000-000000000001"
    error_message = "prefect_webhook should use the provided service_account_id when defined"
  }
}

run "ensure_uses_eventgrid_system_topic_id" {
  variables {
    create_eventgrid_system_topic = false
    eventgrid_system_topic_id = "overridden"
  }

  assert {
    condition = try(azurerm_eventgrid_event_subscription.this.scope) == "overridden"
    error_message = "scope should be overridden when eventgrid_system_topic_id is defined"
  }

  assert {
    condition = length(azurerm_eventgrid_system_topic.this) == 0
    error_message = "An Event Grid system topic should not be created when create_eventgrid_system_topic = false"
  }
}

run "ensure_overrides" {
  variables {
    create_service_account = true
    eventgrid_system_topic_name_override = "overridden"
    eventgrid_event_subscription_name_override = "overridden"
    prefect_service_account_name_override = "overridden"
    prefect_webhook_name_override = "overridden"
    prefect_webhook_description_override = "overridden"
    prefect_webhook_template_override = {
      overridden = true
    }
  }

  assert {
    condition = azurerm_eventgrid_system_topic.this[0].name == "overridden"
    error_message = "The azurerm_eventgrid_system_topic resource did not have its name property correctly overridden."
  }

  assert {
    condition = azurerm_eventgrid_event_subscription.this.name == "overridden"
    error_message = "The azurerm_eventgrid_event_subscription resource did not have its name property correctly overridden."
  }

  assert {
    condition = prefect_service_account.this[0].name == "overridden"
    error_message = "The prefect_service_account resource did not have its name property correctly overridden."
  }

  assert {
    condition = prefect_webhook.this.name == "overridden"
    error_message = "The prefect_webhook resource did not have its name property correctly overridden."
  }

  assert {
    condition = prefect_webhook.this.description == "overridden"
    error_message = "The prefect_webhook resource did not have its description property correctly overridden."
  }

  assert {
    condition = prefect_webhook.this.template == jsonencode({overridden = true})
    error_message = "The prefect_webhook resource did not have its template property correctly overridden."
  }
}

run "ensure_failure" {
  variables {
    create_service_account = true
    prefect_service_account_id = "overridden"
  }
  
  command = plan
  
  expect_failures = [prefect_service_account.this[0]]
}