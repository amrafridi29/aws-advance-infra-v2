# Example: Basic Security Module Usage
# This file shows how to use the security module with minimal configuration

module "security" {
  source = "../"

  # Required variables
  environment  = "staging"
  project_name = "my-project"
  vpc_id       = "vpc-12345678"

  # Tags
  tags = {
    Environment = "staging"
    Project     = "my-project"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "vpc_flow_log_role_arn" {
  description = "VPC Flow Log IAM role ARN"
  value       = module.security.vpc_flow_log_role_arn
}

output "app_security_group_id" {
  description = "Application security group ID"
  value       = module.security.app_security_group_id
}

output "kms_key_arn" {
  description = "KMS encryption key ARN"
  value       = module.security.kms_key_arn
}

output "security_summary" {
  description = "Security infrastructure summary"
  value       = module.security.security_summary
}
