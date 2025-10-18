terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "s3" {
    bucket  = "terraform-state-897729105223-eu-west-1"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
    profile = "admin-profile"
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "admin-profile"
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

module "iam_provider" {
  source = "./iam/provider"
}

module "s3" {
  source = "./s3"
}

module "lambda" {
  source = "./lambda"
}

module "api_gateway" {
  source = "./api-gateway"
}

module "route53" {
  source = "./route53"
  api_gateway_domain_name = module.api_gateway.api_gateway_domain_name
  api_gateway_zone_id     = module.api_gateway.api_gateway_zone_id
}