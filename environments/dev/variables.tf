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