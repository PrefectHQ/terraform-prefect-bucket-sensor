terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.1, < 7"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = "< 4"
    }
  }
}
