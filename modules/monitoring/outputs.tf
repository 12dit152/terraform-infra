output "private_subnet_flow_log_allow_arn" {
  description = "ARN of private subnet allow flow log group"
  value       = aws_cloudwatch_log_group.private_subnet_flow_log_allow.arn
}

output "private_subnet_flow_log_deny_arn" {
  description = "ARN of private subnet deny flow log group"
  value       = aws_cloudwatch_log_group.private_subnet_flow_log_deny.arn
}

output "public_subnet_flow_log_allow_arn" {
  description = "ARN of public subnet allow flow log group"
  value       = aws_cloudwatch_log_group.public_subnet_flow_log_allow.arn
}

output "public_subnet_flow_log_deny_arn" {
  description = "ARN of public subnet deny flow log group"
  value       = aws_cloudwatch_log_group.public_subnet_flow_log_deny.arn
}