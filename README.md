# terraform-prefect-bucket-sensor
Terraform module which creates an object storage bucket, event notifications, publishing topic, and a Prefect Webhook endpoint.

Currently supported:

- AWS (S3 + EventBridge)
- Azure (Blob Storage + Event Grid)
- GCP (Google Cloud Storage + PubSub)

Use this module to provision an off-the-shelf bucket sensor integration to trigger Prefect automations and flows whenever bucket lifecycle events occur.

## Usage
Use one of the packaged submodules. The root module has been deprecated.

### AWS / S3 + EventBridge

```hcl
terraform {
  required_providers {
    prefect = {
      source = "prefecthq/prefect"
    }
  }
}

provider "prefect" {
  # insert your Prefect API key here
}

provider "aws" {
  # insert your AWS credentials here
}

module "s3_to_prefect" {
  source = "prefecthq/bucket-sensor/prefect//modules/s3"

  bucket_name = "s3-to-prefect-source-bucket"
  topic_name  = "s3-to-prefect-event-topic"

  # Eventbridge S3 Event types:
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventBridge.html
  bucket_event_notification_types = ["Object Created", "Object Deleted"]

  webhook_name = "s3-webhook"
  # Prefect Webhook templates:
  # https://docs.prefect.io/v3/automate/events/webhook-triggers#webhook-templates
  #
  # S3 Eventbridge Event Structure:
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/ev-events.html
  webhook_template = {
    event = "S3 {{ body.detail.reason }}",
    resource = {
      "prefect.resource.id" = "s3.bucket.{{ body.detail.bucket.name }}",
      "object-key"          = "{{ body.detail.object.key }}",
    }
  }
}
```

### Azure / Blob Storage + Event Grid

```hcl
provider "prefect" {
  # insert your Prefect API key here
}

provider "azurerm" {
  # insert your Azure credentials here
  features {}
}

module "azure_blob_to_prefect" {
  source = "prefecthq/bucket-sensor/prefect//modules/azure"

  resource_group_name = "example"
  storage_account_name = "example"
  location = "us-east1"

  # can enable if pro or enterprise, adds auth to webhook endpoint
  create_service_account = True
}
```

### GCP / Google Cloud Storage + PubSub

```hcl
terraform {
  required_providers {
    prefect = {
      source = "prefecthq/prefect"
    }
  }
}

provider "prefect" {
  # insert your Prefect API key here
}

provider "google" {
  # insert your GCP credentials here
}

module "gcs_to_prefect" {
  source = "prefecthq/bucket-sensor/prefect//modules/gcs"

  bucket_name = "gcs-to-prefect-source-bucket"
  topic_name  = "gcs-to-prefect-event-topic"

  # GCS Event Notification Types:
  # https://cloud.google.com/storage/docs/pubsub-notifications#attributes
  bucket_event_notification_types = ["OBJECT_FINALIZE", "OBJECT_DELETE"]

  webhook_name = "gcs-webhook"
  # Prefect Webhook templates:
  # https://docs.prefect.io/v3/automate/events/webhook-triggers#webhook-templates
  #
  # GCS Event Notification Structure:
  # https://cloud.google.com/storage/docs/pubsub-notifications#attributes
  webhook_template = {
    event = "GCS {{ body.message.attributes.eventType }}",
    resource = {
      "prefect.resource.id" = "gcs.bucket.{{ body.message.attributes.bucketId }}",
      "object-key"          = "{{ body.message.attributes.objectId }}",
    }
  }
}
```

## Requirements

**Installation Dependencies**

- Terraform >= 1.3.0
- Prefect >= 2.13.5
- terraform-provider-google >= 6.1
- terraform-provider-aws >= 5.0