terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 8"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = ">= 2.13.5, < 3"
    }
  }
}
