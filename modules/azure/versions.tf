terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4, < 6"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = ">= 2.13.5, < 4"
    }
  }
}
