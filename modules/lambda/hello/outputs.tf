output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.spring_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.spring_lambda.arn
}

output "lambda_alias_name" {
  description = "Name of the Lambda alias"
  value       = aws_lambda_alias.dev.name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}