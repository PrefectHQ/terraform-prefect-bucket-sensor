resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.bucket.id
  eventbridge = true
}

resource "aws_cloudwatch_event_rule" "s3" {
  name        = "${var.bucket_name}-events-to-prefect"
  description = "Capture each S3 update to a Prefect webhook endpoint"

  event_pattern = jsonencode({
    source      = ["aws.s3"],
    detail-type = var.bucket_event_notification_types,
    detail = {
      bucket = {
        name = [var.bucket_name]
      }
    }
  })
}

resource "aws_cloudwatch_event_connection" "prefect" {
  name               = "${var.topic_name}-event-connection"
  description        = "A connection to a Prefect webhook endpoint"
  authorization_type = "BASIC"

  auth_parameters {
    basic {
      username = "no-op"
      password = "no-op"
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "prefect" {
  name                             = "${var.topic_name}-event-destination"
  description                      = "An API Destination for a Prefect webhook endpoint"
  invocation_endpoint              = prefect_webhook.webhook.endpoint
  http_method                      = "POST"
  invocation_rate_limit_per_second = 20
  connection_arn                   = aws_cloudwatch_event_connection.prefect.arn
}

resource "aws_iam_role" "eventbridge_invoke_api" {
  name = "${var.topic_name}-eventbridge-api-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_invoke_api" {
  name = "${var.topic_name}-invoke-api-destination"
  role = aws_iam_role.eventbridge_invoke_api.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["events:InvokeApiDestination"]
      Resource = ["*"]
    }]
  })
}

resource "aws_cloudwatch_event_target" "prefect" {
  rule     = aws_cloudwatch_event_rule.s3.name
  arn      = aws_cloudwatch_event_api_destination.prefect.arn
  role_arn = aws_iam_role.eventbridge_invoke_api.arn
}

locals {
  default_webhook_template = {
    event = "S3 {{ body.detail.reason }}",
    resource = {
      "prefect.resource.id" = "s3.bucket.{{ body.detail.bucket.name }}",
      "object-key"          = "{{ body.detail.object.key }}",
    }
  }
}

resource "prefect_webhook" "webhook" {
  name        = var.webhook_name
  description = "Webhook for S3 bucket event notifications"
  enabled     = true
  template    = jsonencode(coalesce(var.webhook_template, local.default_webhook_template))
}
