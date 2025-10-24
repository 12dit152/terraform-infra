variable "metric_stream_name" {
  description = "Name of the CloudWatch metric stream (will have '-firehose' suffix added for Firehose)"
  type        = string
  default = "grafana-cloud-metric-stream-eu-west-1"
}

variable "grafana_metrics_endpoint" {
  description = "Grafana Cloud metrics endpoint URL for delivering metrics"
  type        = string
}

variable "grafana_metrics_instance_id" {
  description = "Grafana Prometheus user/instance ID"
  type        = string
}

variable "grafana_metrics_write_token" {
  description = "Grafana Cloud token with the metrics:write scope"
  type        = string
  sensitive   = true
}

variable "existing_fallback_s3_arn" {
  description = "ARN of an existing S3 bucket to use for Firehose backup. Example: arn:aws:s3:::my-bucket"
  type        = string
}