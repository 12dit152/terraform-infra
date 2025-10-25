variable "existing_lambda_role_arn" {
    description = "ARN of an existing Lambda execution role. If provided, this role will be used instead of creating a new one."
    type        = string
}

# CloudWatch Log Group with 1 day retention
resource "aws_cloudwatch_log_group" "lambda_logs_gen_ai" {
  name              = "/aws/lambda/spring-lambda-gen-ai"
  retention_in_days = 1
}

# Lambda function (placeholder - will be updated by GitHub Actions)
resource "aws_lambda_function" "spring_lambda_gen_ai" {
  function_name = "spring-lambda-gen-ai"
  role         = var.existing_lambda_role_arn
  handler      = "com.samardash.lamda.handler.LambdaHandler::handleRequest"
  runtime      = "java21"
  timeout      = 900
  memory_size  = 512
  architectures = ["arm64"]

  snap_start {
    apply_on = "PublishedVersions"
  }

  # Placeholder ZIP - will be updated by GitHub Actions
  filename         = "placeholder.zip"
  source_code_hash = data.archive_file.placeholder.output_base64sha256

  environment {
    variables = {
      JAVA_TOOL_OPTIONS      = "-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
      SPRING_PROFILES_ACTIVE = "dev"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs_gen_ai
  ]

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

# Placeholder ZIP file
data "archive_file" "placeholder" {
  type        = "zip"
  output_path = "placeholder.zip"
  source {
    content  = "placeholder"
    filename = "placeholder.txt"
  }
}
# Lambda alias for dev environment
resource "aws_lambda_alias" "dev" {
  name             = "dev"
  description      = "Development environment alias"
  function_name    = aws_lambda_function.spring_lambda_gen_ai.function_name
  function_version = "$LATEST"

  lifecycle {
    ignore_changes = [function_version]
  }
}

