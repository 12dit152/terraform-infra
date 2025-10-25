// main IAM role used by the firehose stream
resource "aws_iam_role" "firehose" {
  name = format("firehose-role-%s", var.metric_stream_name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# allow firehose to emit error logs
resource "aws_iam_role_policy" "firehose" {
  name = format("firehose-%s", var.metric_stream_name)
  role = aws_iam_role.firehose.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = ["*"]
        Action   = ["logs:PutLogEvents"]
      }
      ,
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject",
        ]
        Resource = [
          var.existing_fallback_s3_arn,
          "${var.existing_fallback_s3_arn}/*",
        ]
      }
    ]
  })
}

// IAM role used by CloudWatch metric stream for forwarding metrics to Firehose
resource "aws_iam_role" "metric_stream_role" {
  name = format("metric-stream-role-%s", var.metric_stream_name)

  # allow metric stream to assume this role
  assume_role_policy = data.aws_iam_policy_document.metric_stream_assume_role.json
}

data "aws_iam_policy_document" "metric_stream_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "metric_stream_role" {
  name = "cloudwatch-metric-stream-policy"
  role = aws_iam_role.metric_stream_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      // allow metric stream to write to firehose
      {
        Action = ["firehose:PutRecord", "firehose:PutRecordBatch"]
        Effect = "Allow"
        Resource = [
          aws_kinesis_firehose_delivery_stream.stream.arn,
        ]
      },
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  name        = format("%s-firehose", var.metric_stream_name)
  destination = "http_endpoint"

  http_endpoint_configuration {
    url                = var.grafana_metrics_endpoint
    name               = "Grafana AWS Metric Stream Destination"
    access_key         = format("%s:%s", var.grafana_metrics_instance_id, var.grafana_metrics_write_token)
    buffering_size     = 5
    buffering_interval = 900
    role_arn           = aws_iam_role.firehose.arn

    request_configuration {
      content_encoding = "GZIP"
    }

    # S3 backup configuration is required for HTTP endpoints; use the provided existing bucket ARN
    s3_configuration {
      role_arn           = aws_iam_role.firehose.arn
      bucket_arn         = var.existing_fallback_s3_arn
      buffering_size     = 5
      buffering_interval = 300
      compression_format = "GZIP"
    }
  }
}

resource "aws_cloudwatch_metric_stream" "metric_stream" {
  name          = var.metric_stream_name
  role_arn      = aws_iam_role.metric_stream_role.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.stream.arn
  output_format = "opentelemetry1.0"

  include_filter {
    namespace = "AWS/Billing"
  }

  include_filter {
    namespace = "AWS/S3"
  }

  include_filter {
    namespace = "AWS/Lambda"
  }
}
