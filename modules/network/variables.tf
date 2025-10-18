variable "private_subnet_flow_log_allow_arn" {
  description = "ARN of CloudWatch log group for private subnet allow traffic"
  type        = string
}

variable "private_subnet_flow_log_deny_arn" {
  description = "ARN of CloudWatch log group for private subnet deny traffic"
  type        = string
}

variable "public_subnet_flow_log_allow_arn" {
  description = "ARN of CloudWatch log group for public subnet allow traffic"
  type        = string
}

variable "public_subnet_flow_log_deny_arn" {
  description = "ARN of CloudWatch log group for public subnet deny traffic"
  type        = string
}

variable "vpc_flow_logs_role_arn" {
  description = "ARN of IAM role for VPC flow logs"
  type        = string
}