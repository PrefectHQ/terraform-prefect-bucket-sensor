provider "prefect" {}

provider "azurerm" {}

module "azure_blob_to_prefect" {
  source = "prefecthq/bucket-sensor/prefect//modules/azure"

  resource_group_name = "example"
  storage_account_name = "example"
  location = "us-east1"

  # can enable if pro or enterprise, adds auth to webhook endpoint
  create_service_account = True
}

output "webhook_url" {
  value = module.azure_blob_to_prefect.prefect_webhook_url
}
