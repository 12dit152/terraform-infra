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

module "compute" {
  source = "../../modules/compute"
}

module "dns" {
  source = "../../modules/dns"
  api_gateway_domain_name = module.compute.api_gateway_domain_name
  api_gateway_zone_id     = module.compute.api_gateway_zone_id
}