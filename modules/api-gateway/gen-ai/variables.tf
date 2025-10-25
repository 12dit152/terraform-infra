variable "lambda_function_arn_gen_ai" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "lambda_function_name_gen_ai" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_alias_name_gen_ai" {
  description = "Name of the Lambda alias"
  type        = string
}

variable "custom_domain_name_gen_ai" {
  description = "Custom domain name for API Gateway"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}