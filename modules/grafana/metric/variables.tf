variable "metric_stream_name" {
  description = "Name of the CloudWatch metric stream (will have '-firehose' suffix added for Firehose)"
  type        = string
  default = "grafana-cloud-metric-stream"
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
  default     = "arn:aws:s3:::grafanalabs-897729105223-eu-west-1"
}

variable "existing_firehose_role_arn" {
  description = "ARN of an existing IAM role to use for Firehose delivery stream"
  type        = string
  default     = "arn:aws:iam::897729105223:role/Firehose-grafana-cloud-metric-stream"
}

variable "existing_metric_stream_role_arn" {
  description = "ARN of an existing IAM role to use for CloudWatch metric stream"
  type        = string
  default     = "arn:aws:iam::897729105223:role/metric-stream-role-grafana-cloud-metric-stream"
}