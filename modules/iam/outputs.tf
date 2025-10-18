output "vpc_flow_logs_role_arn" {
  description = "ARN of VPC flow logs role"
  value       = aws_iam_role.vpc_flow_logs.arn
}

output "github_actions_role_arn" {
  description = "ARN of GitHub Actions role"
  value       = aws_iam_role.github_actions_role.arn
}