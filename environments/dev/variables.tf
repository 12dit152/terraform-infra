variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "grafana_log_url" {}
variable "grafana_log_username" {}
variable "grafana_log_key" {}

variable "grafana_metrics_endpoint" {}
variable "grafana_metrics_instance_id" {}
variable "grafana_metrics_write_token" {}
