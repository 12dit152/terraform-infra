# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "spring-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "ssm_read_only" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# CloudWatch Log Group with 1 day retention
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/spring-lambda-hello"
  retention_in_days = 1
}

# Lambda function (placeholder - will be updated by GitHub Actions)
resource "aws_lambda_function" "spring_lambda" {
  function_name = "spring-lambda-hello"
  role         = aws_iam_role.lambda_role.arn
  handler      = "com.samardash.lamda.LambdaHandler::handleRequest"
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
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.ssm_read_only,
    aws_cloudwatch_log_group.lambda_logs
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

# SSM Parameters
resource "aws_ssm_parameter" "backend_url" {
  name  = "/lambda-hello/dev/backend/url"
  type  = "String"
  value = "dummy"
}

resource "aws_ssm_parameter" "backend_api_key" {
  name  = "/lambda-hello/dev/backend/api-key"
  type  = "SecureString"
  value = "dummy"
}

# Lambda alias for dev environment
resource "aws_lambda_alias" "dev" {
  name             = "dev"
  description      = "Development environment alias"
  function_name    = aws_lambda_function.spring_lambda.function_name
  function_version = "$LATEST"

  lifecycle {
    ignore_changes = [function_version]
  }
}

