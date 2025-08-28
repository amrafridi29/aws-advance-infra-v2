# Backend Infrastructure - Outputs
# This file defines all outputs from the backend infrastructure

# S3 Backend Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = module.s3_backend.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = module.s3_backend.bucket_arn
}

output "s3_bucket_region" {
  description = "Region of the S3 bucket for Terraform state"
  value       = module.s3_backend.bucket_region
}

# DynamoDB Backend Outputs
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  value       = module.dynamodb_backend.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for Terraform state locking"
  value       = module.dynamodb_backend.table_arn
}

output "dynamodb_table_region" {
  description = "Region of the DynamoDB table for Terraform state locking"
  value       = data.aws_region.current.name
}

# Combined Backend Configuration
output "backend_configuration" {
  description = "Terraform backend configuration for environments"
  value = {
    bucket         = module.s3_backend.bucket_name
    key            = "global/terraform.tfstate"
    region         = module.s3_backend.bucket_region
    dynamodb_table = module.dynamodb_backend.table_name
    encrypt        = true
  }
}

# Usage Instructions
output "usage_instructions" {
  description = "Instructions for using this backend in environments"
  value       = <<-EOT
    To use this backend in your environment configurations, add the following to your terraform block:
    
    terraform {
      backend "s3" {
        bucket         = "${module.s3_backend.bucket_name}"
        key            = "environments/[ENVIRONMENT_NAME]/terraform.tfstate"
        region         = "${module.s3_backend.bucket_region}"
        dynamodb_table = "${module.dynamodb_backend.table_name}"
        encrypt        = true
      }
    }
    
    Replace [ENVIRONMENT_NAME] with your environment (e.g., staging, production)
  EOT
}
