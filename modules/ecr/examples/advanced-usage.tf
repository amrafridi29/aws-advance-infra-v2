# Advanced ECR Usage Example
# This example shows production-ready ECR configuration with all features

module "ecr_advanced" {
  source = "../"

  environment  = "production"
  project_name = "enterprise-app"

  # Enable both repositories
  enable_frontend_repository = true
  enable_backend_repository  = true

  # Advanced features
  enable_image_scanning      = true
  enable_lifecycle_policies  = true
  enable_repository_policies = true
  max_image_count            = 20

  tags = {
    Environment = "production"
    Project     = "enterprise-app"
    Purpose     = "Production ECR Setup"
    CostCenter  = "engineering"
    Owner       = "devops-team"
  }
}

# Advanced outputs
output "all_repository_urls" {
  description = "All ECR repository URLs"
  value       = module.ecr_advanced.repository_urls
}

output "frontend_repository_details" {
  description = "Frontend repository details"
  value = {
    url  = module.ecr_advanced.frontend_repository_url
    arn  = module.ecr_advanced.frontend_repository_arn
    name = module.ecr_advanced.frontend_repository_name
  }
}

output "backend_repository_details" {
  description = "Backend repository details"
  value = {
    url  = module.ecr_advanced.backend_repository_url
    arn  = module.ecr_advanced.backend_repository_arn
    name = module.ecr_advanced.backend_repository_name
  }
}

output "ecr_infrastructure_summary" {
  description = "Complete ECR infrastructure summary"
  value       = module.ecr_advanced.ecr_summary
}
