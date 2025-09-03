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

# IAM Module Outputs
output "iam_outputs" {
  description = "IAM module outputs"
  value       = module.iam
}

# Encryption Module Outputs
output "encryption_outputs" {
  description = "Encryption module outputs"
  value       = module.encryption
}

# ECR Module Outputs
output "ecr_outputs" {
  description = "ECR module outputs"
  value       = module.ecr
}

# ECR Repository URLs (for easy access)
output "frontend_repository_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr.frontend_repository_url
}

output "backend_repository_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr.backend_repository_url
}

# Security Module Outputs
output "security_outputs" {
  description = "Security module outputs"
  value       = module.security
}

# Storage Module Outputs
output "storage_outputs" {
  description = "Storage module outputs"
  value       = module.storage
}

# Compute Module Outputs
output "compute_outputs" {
  description = "Compute module outputs"
  value       = module.compute
}

# Load Balancer Outputs (from Networking Module)
output "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  value       = module.networking.load_balancer_dns_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.networking.target_group_arn
}

# Monitoring Module Outputs
output "monitoring_outputs" {
  description = "Monitoring module outputs"
  value       = module.monitoring
}

# CloudFront Module Outputs
output "cloudfront_outputs" {
  description = "CloudFront module outputs"
  value       = module.cloudfront
}

# CloudFront Domain Name (for easy access)
output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

# Route 53 Outputs
# output "route53_outputs" {
#   description = "Outputs from the Route 53 module"
#   value       = module.route53.route53_summary
# }

# output "custom_domain_name" {
#   description = "Custom domain name"
#   value       = module.route53.full_domain_name
# }

# output "name_servers" {
#   description = "Name servers for DNS configuration"
#   value       = module.route53.name_servers
# }

# ElastiCache Outputs
output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = module.elasticache.elasticache_cluster_id
}

output "elasticache_endpoint" {
  description = "ElastiCache primary endpoint"
  value       = module.elasticache.elasticache_endpoint
}

output "elasticache_port" {
  description = "ElastiCache port"
  value       = module.elasticache.elasticache_port
}

output "elasticache_connection_string" {
  description = "Redis connection string for applications"
  value       = module.elasticache.elasticache_connection_string
}

output "elasticache_security_group_id" {
  description = "ElastiCache security group ID"
  value       = module.elasticache.elasticache_security_group_id
}

output "elasticache_summary" {
  description = "Summary of ElastiCache configuration"
  value       = module.elasticache.elasticache_summary
}
