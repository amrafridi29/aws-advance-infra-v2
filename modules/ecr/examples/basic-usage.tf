# Basic ECR Usage Example
# This example shows minimal ECR configuration

module "ecr_basic" {
  source = "../"

  environment  = "staging"
  project_name = "my-app"

  # Enable only frontend repository
  enable_frontend_repository = true
  enable_backend_repository  = false

  # Basic features
  enable_image_scanning     = true
  enable_lifecycle_policies = true
  max_image_count           = 5

  tags = {
    Environment = "staging"
    Project     = "my-app"
    Purpose     = "Basic ECR Setup"
  }
}

# Outputs for basic usage
output "frontend_repository_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr_basic.frontend_repository_url
}

output "ecr_summary" {
  description = "ECR infrastructure summary"
  value       = module.ecr_basic.ecr_summary
}
