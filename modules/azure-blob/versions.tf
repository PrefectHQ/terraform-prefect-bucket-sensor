terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = ">= 2.13.5, < 3"
    }
  }
}
