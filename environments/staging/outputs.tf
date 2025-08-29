# Staging Environment - Outputs
# This file defines all outputs from the staging environment

# Environment Information
output "environment_info" {
  description = "Information about the staging environment"
  value = {
    environment     = var.environment
    region          = data.aws_region.current.name
    account_id      = data.aws_caller_identity.current.account_id
    vpc_id          = module.networking.vpc_id
    vpc_cidr        = var.vpc_cidr
    public_subnets  = module.networking.public_subnet_ids
    private_subnets = module.networking.private_subnet_ids
  }
}

# Networking Module Outputs
output "networking_outputs" {
  description = "Networking module outputs"
  value       = module.networking
}

# Security Module Outputs
output "security_outputs" {
  description = "Security module outputs"
  value       = module.security
}

# Storage Module Outputs
# output "storage_outputs" {
#   description = "Storage module outputs"
#   value = module.storage
# }

# Compute Module Outputs
# output "compute_outputs" {
#   description = "Compute module outputs"
#   value = module.compute
# }

# Monitoring Module Outputs
output "monitoring_outputs" {
  description = "Monitoring module outputs"
  value       = module.monitoring
}
