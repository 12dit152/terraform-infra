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
    key     = "prod/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
    profile = "admin-profile"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "admin-profile"
}