module "monitoring" {
  source = "../../modules/monitoring"
}

module "iam" {
  source = "../../modules/iam"
}

module "network" {
  source = "../../modules/network"
  private_subnet_flow_log_allow_arn = module.monitoring.private_subnet_flow_log_allow_arn
  private_subnet_flow_log_deny_arn  = module.monitoring.private_subnet_flow_log_deny_arn
  public_subnet_flow_log_allow_arn  = module.monitoring.public_subnet_flow_log_allow_arn
  public_subnet_flow_log_deny_arn   = module.monitoring.public_subnet_flow_log_deny_arn
  vpc_flow_logs_role_arn            = module.iam.vpc_flow_logs_role_arn
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.samar_vpc_id
}

module "storage" {
  source = "../../modules/storage"
}

module "lambda" {
  source = "../../modules/lambda"
}

module "api_gateway" {
  source               = "../../modules/api-gateway"
  lambda_function_arn  = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name
  lambda_alias_name    = module.lambda.lambda_alias_name
  custom_domain_name   = "api.samardash.com"
  certificate_arn      = "arn:aws:acm:eu-west-1:897729105223:certificate/5d09b88a-d04f-49cd-8b24-3e87ff5a4e4c"
}

module "dns" {
  source = "../../modules/dns"
  api_gateway_domain_name = module.api_gateway.api_gateway_domain_name
  api_gateway_zone_id     = module.api_gateway.api_gateway_zone_id
}

module "billing" {
  source      = "../../modules/billing"
  alert_email = var.alert_email
}