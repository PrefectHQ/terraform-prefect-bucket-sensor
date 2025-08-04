mock_provider "azurerm" {
  override_data {
    target = data.azurerm_storage_account.this
    values = {
      id   = "/tenants/00000000-0000-0000-0000-000000000000/providers/Microsoft.Management/managementGroups/mock"
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
  location = "us-east"
  resource_group_name = "mock"
  storage_account_name = "mock"
}

run "test" {
  variables {
    create_service_account = true
  }

  assert {
    condition = try(prefect_service_account.this[0], null) != null
    error_message   = "foo"
  }
}

run "module" {
  variables {
    create_service_account = false
  }

  assert {
    condition = try(prefect_service_account.this[0], null) == null
    error_message   = "foo"
  }
}
