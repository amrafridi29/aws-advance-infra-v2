# Backend Infrastructure - Main Configuration
# This file orchestrates the creation of S3 and DynamoDB resources for Terraform backend

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        Purpose     = "Terraform Backend Infrastructure"
        ManagedBy   = "Terraform"
      },
      var.tags
    )
  }
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming
locals {
  # Generate unique names if not provided
  s3_bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : "terraform-state-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  dynamodb_table_name = var.dynamodb_table_name != "" ? var.dynamodb_table_name : "terraform-locks-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "Terraform Backend Infrastructure"
    ManagedBy   = "Terraform"
    Component   = "Backend"
  }
}

# S3 Backend Module
module "s3_backend" {
  source = "./s3"

  bucket_name       = local.s3_bucket_name
  enable_versioning = var.enable_s3_versioning
  enable_encryption = var.enable_s3_encryption
  project_name      = var.project_name
  environment       = var.environment
  tags              = local.common_tags
}

# DynamoDB Backend Module
module "dynamodb_backend" {
  source = "./dynamodb"

  table_name                    = local.dynamodb_table_name
  enable_point_in_time_recovery = var.enable_dynamodb_point_in_time_recovery
  project_name                  = var.project_name
  environment                   = var.environment
  tags                          = local.common_tags
}
