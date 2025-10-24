variable "grafana_log_url" {
  type        = string
  description = "This is the Grafana Cloud Loki URL that logs will be forwarded to."
  default     = ""
}

variable "grafana_log_username" {
  type        = string
  description = "The basic auth username for Grafana Cloud Loki."
  default     = ""
}

variable "grafana_log_key" {
  type        = string
  description = "The basic auth password for Grafana Cloud Loki (your Grafana.com API Key)."
  sensitive   = true
  default     = ""
}

variable "log_group_names" {
  type        = list(string)
  description = "List of CloudWatch Log Group names to create Subscription Filters for (ex. /aws/lambda/my-log-group)."
  default     = ["cloudfront-log"]
}

variable "keep_stream" {
  type        = string
  description = "Determines whether to keep the CloudWatch Log Stream value as a Loki label when writing logs from lambda-promtail."
  default     = "false"
}

variable "extra_labels" {
  type        = string
  description = "Comma separated list of extra labels, in the format 'name1,value1,name2,value2,...,nameN,valueN' to add to entries forwarded by lambda-promtail."
  default     = ""
}

variable "batch_size" {
  type        = string
  description = "Determines when to flush the batch of logs (bytes)."
  default     = ""
}

variable "function_name_suffix" {
  type        = string
  description = "Suffix to append to function and log group names (e.g., '-us' for US region)"
  default     = "us-east-1"
}

variable "existing_role_arn" {
  type        = string
  description = "ARN of existing IAM role to use when reuse_existing_role is true"
  default     = "arn:aws:iam::897729105223:role/GrafanaLabsCloudWatchLogsIntegration"
}

variable "s3_bucket" {
type        = string
description = "The name of the bucket where to upload the 'lambda-promtail.zip' file."
default     = "grafanalabs-897729105223-us-east-1"
}

variable "s3_key" {
type        = string
description = "The desired path where to upload the 'lambda-promtail.zip' file (defaults to the root folder)."
default     = "lambda-promtail.zip"
}