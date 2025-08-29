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

  # Tags
  tags = local.common_tags
}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  environment  = var.environment
  project_name = var.project_name

  # IAM Roles
  create_app_role     = true
  create_admin_role   = false
  create_service_role = false

  # VPC Flow Log Role (required for monitoring)
  create_vpc_flow_log_role = true

  tags = local.common_tags
}

# Encryption Module
module "encryption" {
  source = "../../modules/encryption"

  environment  = var.environment
  project_name = var.project_name

  # Basic encryption
  enable_kms_encryption = true

  tags = local.common_tags
}

# Security Module
module "security" {
  source = "../../modules/security"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id

  # Security Groups
  create_security_groups = true
  allowed_cidr_blocks    = var.allowed_cidr_blocks
  enable_ssh_access      = false # Disable SSH for staging security
  enable_http_access     = true  # Enable HTTP for staging
  enable_https_access    = true  # Enable HTTPS for staging
  enable_database_access = true  # Enable database access
  database_port          = 3306  # Default MySQL port

  tags = local.common_tags
}

# Storage Module
module "storage" {
  source = "../../modules/storage"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.private_subnet_ids

  # S3 Storage
  enable_s3_storage = true

  # RDS Database (disabled for staging - requires password)
  enable_rds            = false
  rds_instance_class    = "db.t3.micro"
  rds_engine            = "mysql"
  rds_engine_version    = "8.0"
  rds_allocated_storage = 5
  rds_database_name     = "staging_db"
  rds_username          = "staging_user"
  rds_password          = "db-password"

  # ElastiCache (disabled for staging)
  enable_elasticache = false

  # EBS Volumes (disabled for staging)
  enable_ebs = false

  # Encryption
  kms_key_arn = module.encryption.main_key_arn

  tags = local.common_tags
}

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

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id

  # VPC Flow Logs
  enable_vpc_flow_logs      = var.enable_flow_logs
  vpc_flow_log_iam_role_arn = module.iam.vpc_flow_log_role_arn

  # CloudWatch Logs
  enable_cloudwatch_logs = var.enable_cloudwatch_logs

  # CloudTrail (disabled for staging - requires S3 bucket)
  enable_cloudtrail = false

  # Alarms and Dashboards (optional for staging)
  enable_alarms     = false
  enable_dashboards = false

  tags = local.common_tags
}

# Outputs are defined in outputs.tf
