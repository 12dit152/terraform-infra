data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}:dev/invocations"
}

resource "aws_api_gateway_integration" "lambda_post" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  resource_id = aws_api_gateway_method.proxy_post.resource_id
  http_method = aws_api_gateway_method.proxy_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}:dev/invocations"
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
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}:dev/invocations"
}

resource "aws_api_gateway_integration" "lambda_root_post" {
  rest_api_id = aws_api_gateway_rest_api.spring_api.id
  resource_id = aws_api_gateway_method.root_post.resource_id
  http_method = aws_api_gateway_method.root_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}:dev/invocations"
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
  function_name = var.lambda_function_name
  qualifier     = var.lambda_alias_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.spring_api.execution_arn}/*/*"
}

# Custom Domain Name
resource "aws_api_gateway_domain_name" "custom" {
  domain_name              = var.custom_domain_name
  regional_certificate_arn = var.certificate_arn
  
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