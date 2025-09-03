# Example: Basic Compute Module Usage
# This file shows how to use the compute module with minimal configuration

module "compute" {
  source = "../"

  # Required variables
  environment        = "staging"
  project_name       = "my-project"
  vpc_id             = "vpc-12345678"
  public_subnet_ids  = ["subnet-12345678", "subnet-87654321"]
  private_subnet_ids = ["subnet-11111111", "subnet-22222222"]

  # ECS Configuration
  enable_ecs = true

  # Load Balancer
  # enable_load_balancer = true

  # ECS Service
  enable_ecs_service = true

  # Service Discovery (disabled for basic usage)
  enable_service_discovery = false

  # Auto Scaling (disabled for basic usage)
  enable_auto_scaling = false

  tags = {
    Environment = "staging"
    Project     = "my-project"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.compute.ecs_cluster_name
}

output "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  value       = module.compute.load_balancer_dns_name
}

output "compute_summary" {
  description = "Compute infrastructure summary"
  value       = module.compute.compute_summary
}
