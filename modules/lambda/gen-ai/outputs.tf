output "lambda_function_name_gen_ai" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.spring_lambda_gen_ai.function_name
}

output "lambda_function_arn_gen_ai" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.spring_lambda_gen_ai.arn
}

output "lambda_alias_name_gen_ai" {
  description = "Name of the Lambda alias"
  value       = aws_lambda_alias.dev.name
}
