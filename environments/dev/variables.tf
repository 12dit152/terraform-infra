variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "alert_email" {
  description = "Email address for budget alerts"
  type        = string
  default     = "toehold.realer.5x@icloud.com"
}