variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "github_org" {}
variable "alert_email" {}

variable "grafana_metrics_endpoint" {}
variable "grafana_metrics_instance_id" {}
variable "grafana_metrics_write_token" {}