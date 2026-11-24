mock_provider "aws" {
  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/mock"
    }
  }

  mock_resource "aws_cloudwatch_event_connection" {
    defaults = {
      arn = "arn:aws:events:us-east-1:123456789012:connection/mock"
    }
  }

  mock_resource "aws_cloudwatch_event_api_destination" {
    defaults = {
      arn = "arn:aws:events:us-east-1:123456789012:api-destination/mock"
    }
  }
}

mock_provider "prefect" {
  mock_resource "prefect_webhook" {
    defaults = {
      endpoint = "https://api.prefect.cloud/hooks/mocked"
    }
  }
}

run "blocks_public_access" {
  assert {
    condition     = aws_s3_bucket_public_access_block.bucket.bucket == aws_s3_bucket.bucket.id
    error_message = "The public access block should apply to the module's bucket."
  }

  assert {
    condition = alltrue([
      aws_s3_bucket_public_access_block.bucket.block_public_acls,
      aws_s3_bucket_public_access_block.bucket.block_public_policy,
      aws_s3_bucket_public_access_block.bucket.ignore_public_acls,
      aws_s3_bucket_public_access_block.bucket.restrict_public_buckets,
    ])
    error_message = "All four S3 public access block settings should be enabled."
  }
}

run "sends_bucket_events_to_eventbridge" {
  assert {
    condition     = aws_s3_bucket_notification.bucket_notification.eventbridge
    error_message = "The bucket should send its event notifications to EventBridge."
  }
}
