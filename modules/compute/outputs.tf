output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.spring_lambda.function_name
}

output "lambda_alias_name" {
  description = "Name of the Lambda alias"
  value       = aws_lambda_alias.dev.name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = aws_api_gateway_stage.dev.invoke_url
}

output "custom_domain_url" {
  description = "Custom domain URL"
  value       = "https://${aws_api_gateway_domain_name.custom.domain_name}"
}

output "api_gateway_domain_name" {
  description = "Regional domain name of API Gateway"
  value       = aws_api_gateway_domain_name.custom.regional_domain_name
}

output "api_gateway_zone_id" {
  description = "Zone ID of API Gateway"
  value       = aws_api_gateway_domain_name.custom.regional_zone_id
}