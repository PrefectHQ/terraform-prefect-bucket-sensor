terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 7"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = ">= 2.13.5, < 4"
    }
  }
}
