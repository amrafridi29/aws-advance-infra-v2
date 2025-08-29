# Example: Basic Monitoring Module Usage
# This file shows how to use the monitoring module with minimal configuration

module "monitoring" {
  source = "../"

  # Required variables
  environment  = "staging"
  project_name = "my-project"
  vpc_id       = "vpc-12345678"

  # VPC Flow Logs
  enable_vpc_flow_logs      = true
  vpc_flow_log_iam_role_arn = "arn:aws:iam::123456789012:role/vpc-flow-log-role"

  # CloudWatch Logs
  enable_cloudwatch_logs = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "vpc_flow_log_ids" {
  description = "VPC Flow Log IDs"
  value       = module.monitoring.vpc_flow_log_ids
}

output "flow_log_group_names" {
  description = "VPC Flow Log group names"
  value       = module.monitoring.flow_log_group_names
}

output "all_log_group_names" {
  description = "All CloudWatch log group names"
  value       = module.monitoring.all_log_group_names
}

output "monitoring_summary" {
  description = "Monitoring infrastructure summary"
  value       = module.monitoring.monitoring_summary
}
