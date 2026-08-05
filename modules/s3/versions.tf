terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5, < 6"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = "< 4"
    }
  }
}
