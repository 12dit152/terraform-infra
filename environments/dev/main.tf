module "monitoring" {
  source = "../../modules/monitoring"
}

module "iam" {
  source     = "../../modules/iam"
  github_org = var.github_org
}

module "network" {
  source                            = "../../modules/network"
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

module "lambda_hello" {
  source = "../../modules/lambda/hello"
}

module "lambda_gen_ai" {
  source                   = "../../modules/lambda/gen-ai"
  existing_lambda_role_arn = var.existing_lambda_role_arn
}

module "api_gateway_hello" {
  source               = "../../modules/api-gateway/hello"
  lambda_function_arn  = module.lambda_hello.lambda_function_arn
  lambda_function_name = module.lambda_hello.lambda_function_name
  lambda_alias_name    = module.lambda_hello.lambda_alias_name
  custom_domain_name   = var.custom_domain_name_api
  certificate_arn      = var.certificate_arn
}

module "api_gateway_gen_ai" {
  source                      = "../../modules/api-gateway/gen-ai"
  lambda_function_arn_gen_ai  = module.lambda_gen_ai.lambda_function_arn_gen_ai
  lambda_function_name_gen_ai = module.lambda_gen_ai.lambda_function_name_gen_ai
  lambda_alias_name_gen_ai    = module.lambda_gen_ai.lambda_alias_name_gen_ai
  custom_domain_name_gen_ai   = var.custom_domain_name_ai
  certificate_arn             = var.certificate_arn
}

module "dns_hello" {
  source                  = "../../modules/dns/hello"
  api_gateway_domain_name = module.api_gateway_hello.api_gateway_domain_name
  api_gateway_zone_id     = module.api_gateway_hello.api_gateway_zone_id
}

module "dns_gen_ai" {
  source                         = "../../modules/dns/gen-ai"
  api_gateway_domain_name_gen_ai = module.api_gateway_gen_ai.api_gateway_domain_name_gen_ai
  api_gateway_zone_id_gen_ai     = module.api_gateway_gen_ai.api_gateway_zone_id_gen_ai
}

module "billing" {
  source      = "../../modules/billing"
  alert_email = var.alert_email
}

module "grafana_logs" {
  source               = "../../modules/grafana/logs"
  grafana_log_url      = var.grafana_log_url
  grafana_log_username = var.grafana_log_username
  grafana_log_key      = var.grafana_log_key
}

module "grafana_metrics" {
  source                      = "../../modules/grafana/metrics"
  grafana_metrics_endpoint    = var.grafana_metrics_endpoint
  grafana_metrics_instance_id = var.grafana_metrics_instance_id
  grafana_metrics_write_token = var.grafana_metrics_write_token
  existing_fallback_s3_arn    = var.existing_fallback_s3_arn
}
