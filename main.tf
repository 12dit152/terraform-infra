terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "cloudwatch" {
  source = "./cloudwatch"
}

module "iam" {
  source = "./iam"
}

module "vpc" {
  source = "./vpc"
  private_subnet_flow_log_allow_arn = module.cloudwatch.private_subnet_flow_log_allow_arn
  private_subnet_flow_log_deny_arn  = module.cloudwatch.private_subnet_flow_log_deny_arn
  public_subnet_flow_log_allow_arn  = module.cloudwatch.public_subnet_flow_log_allow_arn
  public_subnet_flow_log_deny_arn   = module.cloudwatch.public_subnet_flow_log_deny_arn
  vpc_flow_logs_role_arn            = module.iam.vpc_flow_logs_role_arn
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = module.vpc.samar_vpc_id
}

module "cache" {
  source = "./elasticache"
  subnet_ids = [module.vpc.public_subnet1_id, module.vpc.public_subnet2_id]
  security_group_ids = [module.security_groups.redis_security_group_id]
}
