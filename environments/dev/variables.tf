variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "github_org" {}
variable "alert_email" {}


variable "grafana_log_url" {}
variable "grafana_log_username" {}
variable "grafana_log_key" {}

variable "grafana_metrics_endpoint" {}
variable "grafana_metrics_instance_id" {}
variable "grafana_metrics_write_token" {}

variable "existing_fallback_s3_arn" {}

variable "existing_lambda_role_arn" {}
variable "certificate_arn" {}
variable "custom_domain_name_api" {}
variable "custom_domain_name_ai" {}