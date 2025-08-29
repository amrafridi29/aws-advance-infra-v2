# Staging Environment - Main Configuration
# This file orchestrates the deployment of all infrastructure components for staging

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration - will be configured after backend deployment
  # Uncomment and configure after backend infrastructure is deployed
  backend "s3" {
    bucket         = "terraform-state-398512629816-us-east-2"
    key            = "environments/staging/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks-398512629816-us-east-2"
    encrypt        = true
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Purpose     = "Staging Infrastructure"
    }
  }
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

# Local values for consistent naming and configuration
locals {
  environment = var.environment

  # Availability zones (limit to 2 for cost optimization in staging)
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Purpose     = "Staging Infrastructure"
    Owner       = var.team_name
    CostCenter  = var.cost_center
  }

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# Networking Module - This is where we USE our module!
module "networking" {
  source = "../../modules/networking"

  # Module variables
  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  project_name         = var.project_name
  availability_zones   = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # Optional networking features
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_flow_logs   = var.enable_flow_logs

  # Tags
  tags = local.common_tags
}

# TODO: Security Module (will create next)
# module "security" {
#   source = "../../modules/security"
#   
#   environment    = var.environment
#   project_name   = var.project_name
#   vpc_id         = module.networking.vpc_id
#   
#   tags = local.common_tags
# }

# TODO: Storage Module (will create next)
# module "storage" {
#   source = "../../modules/storage"
#   
#   environment    = var.environment
#   project_name   = var.project_name
#   vpc_id         = module.networking.vpc_id
#   subnet_ids     = module.networking.private_subnet_ids
#   
#   tags = local.common_tags
# }

# TODO: Compute Module (will create next)
# module "compute" {
#   source = "../../modules/compute"
#   
#   environment        = var.environment
#   project_name       = var.project_name
#   vpc_id            = module.networking.vpc_id
#   public_subnet_ids = module.networking.public_subnet_ids
#   private_subnet_ids = module.networking.private_subnet_ids
#   security_group_ids = [module.security.app_security_group_id]
#   
#   tags = local.common_tags
# }

# TODO: Monitoring Module (will create next)
# module "monitoring" {
#   source = "../../modules/monitoring"
#   
#   environment    = var.environment
#   project_name   = var.project_name
#   vpc_id         = module.networking.vpc_id
#   
#   tags = local.common_tags
# }

# Outputs are defined in outputs.tf
