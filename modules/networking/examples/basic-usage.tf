# Example: Basic Networking Module Usage
# This file shows how to use the networking module with minimal configuration

module "networking" {
  source = "../"

  # Required variables
  vpc_cidr           = "10.0.0.0/16"
  environment        = "staging"
  project_name       = "my-project"
  availability_zones = ["us-west-2a", "us-west-2b"]

  # Tags
  tags = {
    Environment = "staging"
    Project     = "my-project"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "network_summary" {
  description = "Network infrastructure summary"
  value       = module.networking.network_summary
}
