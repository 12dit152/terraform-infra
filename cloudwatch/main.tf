resource "aws_cloudwatch_log_group" "private_subnet_flow_log_allow" {
  name              = "private-subnet-flow-log-allow"
  retention_in_days = 90 # 3 months
}

resource "aws_cloudwatch_log_group" "private_subnet_flow_log_deny" {
  name              = "private-subnet-flow-log-deny"
  retention_in_days = 90 # 3 months
}

resource "aws_cloudwatch_log_group" "public_subnet_flow_log_allow" {
  name              = "public-subnet-flow-log-allow"
  retention_in_days = 90 # 3 months
}

resource "aws_cloudwatch_log_group" "public_subnet_flow_log_deny" {
  name              = "public-subnet-flow-log-deny"
  retention_in_days = 90 # 3 months
}

output "private_subnet_flow_log_allow_arn" {
  value = aws_cloudwatch_log_group.private_subnet_flow_log_allow.arn
}

output "private_subnet_flow_log_deny_arn" {
  value = aws_cloudwatch_log_group.private_subnet_flow_log_deny.arn
}

output "public_subnet_flow_log_allow_arn" {
  value = aws_cloudwatch_log_group.public_subnet_flow_log_allow.arn
}

output "public_subnet_flow_log_deny_arn" {
  value = aws_cloudwatch_log_group.public_subnet_flow_log_deny.arn
}
