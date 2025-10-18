data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
      SPRING_PROFILES_ACTIVE = "local"
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

# API Gateway REST API
resource "aws_api_gateway_rest_api" "spring_api" {
  name        = "spring-lambda-api"
  description = "API Gateway for Spring Lambda function"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway Resource (proxy)
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  parent_id   = aws_api_gateway_rest_api.spring_api.root_resource_id
  path_part   = "{proxy+}"
}

# API Gateway Methods (GET and POST only)
resource "aws_api_gateway_method" "proxy_get" {
  rest_api_id   = aws_api_gateway_rest_api.spring_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_post" {
  rest_api_id   = aws_api_gateway_rest_api.spring_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway Integrations with Lambda
resource "aws_api_gateway_integration" "lambda_get" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  resource_id = aws_api_gateway_method.proxy_get.resource_id
  http_method = aws_api_gateway_method.proxy_get.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:spring-lambda-hello:dev/invocations"
}

resource "aws_api_gateway_integration" "lambda_post" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  resource_id = aws_api_gateway_method.proxy_post.resource_id
  http_method = aws_api_gateway_method.proxy_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:spring-lambda-hello:dev/invocations"
}

# Root methods for root path (GET and POST only)
resource "aws_api_gateway_method" "root_get" {
  rest_api_id   = aws_api_gateway_rest_api.spring_api.id
  resource_id   = aws_api_gateway_rest_api.spring_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "root_post" {
  rest_api_id   = aws_api_gateway_rest_api.spring_api.id
  resource_id   = aws_api_gateway_rest_api.spring_api.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root_get" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  resource_id = aws_api_gateway_method.root_get.resource_id
  http_method = aws_api_gateway_method.root_get.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:spring-lambda-hello:dev/invocations"
}

resource "aws_api_gateway_integration" "lambda_root_post" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  resource_id = aws_api_gateway_method.root_post.resource_id
  http_method = aws_api_gateway_method.root_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:spring-lambda-hello:dev/invocations"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.lambda_get,
    aws_api_gateway_integration.lambda_post,
    aws_api_gateway_integration.lambda_root_get,
    aws_api_gateway_integration.lambda_root_post,
  ]

  rest_api_id = aws_api_gateway_rest_api.spring_api.id
}

# API Gateway Stage
resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.spring_api.id
  stage_name    = "dev"
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.spring_lambda.function_name
  qualifier     = aws_lambda_alias.dev.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.spring_api.execution_arn}/*/*"
}

# Custom Domain Name
resource "aws_api_gateway_domain_name" "custom" {
  domain_name              = "api.samardash.com"
  regional_certificate_arn = "arn:aws:acm:eu-west-1:897729105223:certificate/5d09b88a-d04f-49cd-8b24-3e87ff5a4e4c"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Mapping
resource "aws_api_gateway_base_path_mapping" "custom" {
  api_id      = aws_api_gateway_rest_api.spring_api.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  domain_name = aws_api_gateway_domain_name.custom.domain_name
}