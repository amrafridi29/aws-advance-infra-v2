# Example: Basic IAM Module Usage
# This file shows how to use the IAM module with minimal configuration

module "iam" {
  source = "../"

  # Required variables
  environment  = "staging"
  project_name = "my-project"

  # IAM Roles
  create_app_role     = true
  create_admin_role   = false
  create_service_role = false

  # VPC Flow Log Role (required for monitoring)
  create_vpc_flow_log_role = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "vpc_flow_log_role_arn" {
  description = "VPC Flow Log IAM role ARN"
  value       = module.iam.vpc_flow_log_role_arn
}

output "app_role_arn" {
  description = "Application IAM role ARN"
  value       = module.iam.app_role_arn
}

output "iam_summary" {
  description = "IAM infrastructure summary"
  value       = module.iam.iam_summary
}
