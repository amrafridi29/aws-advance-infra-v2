# Example: Basic Storage Module Usage
# This file shows how to use the storage module with minimal configuration

module "storage" {
  source = "../"

  # Required variables
  environment  = "staging"
  project_name = "my-project"
  vpc_id       = "vpc-12345678"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]

  # S3 Storage
  enable_s3_storage = true

  # RDS Database (enabled for basic usage)
  enable_rds   = true
  rds_password = "db-password" # Required when RDS is enabled

  # ElastiCache (disabled for basic usage)
  enable_elasticache = false

  # EBS Volumes (disabled for basic usage)
  enable_ebs = false

  tags = {
    Environment = "staging"
    Project     = "my-project"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "s3_bucket_names" {
  description = "S3 bucket names"
  value       = module.storage.s3_bucket_names
}

output "storage_summary" {
  description = "Storage infrastructure summary"
  value       = module.storage.storage_summary
}
