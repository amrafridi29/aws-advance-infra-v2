# ECR Module - Outputs
# This file defines all outputs from the ECR module

# Frontend Repository Outputs
output "frontend_repository_url" {
  description = "URL of the frontend ECR repository"
  value       = var.enable_frontend_repository ? aws_ecr_repository.frontend[0].repository_url : null
}

output "frontend_repository_arn" {
  description = "ARN of the frontend ECR repository"
  value       = var.enable_frontend_repository ? aws_ecr_repository.frontend[0].arn : null
}

output "frontend_repository_name" {
  description = "Name of the frontend ECR repository"
  value       = var.enable_frontend_repository ? aws_ecr_repository.frontend[0].name : null
}

# Backend Repository Outputs
output "backend_repository_url" {
  description = "URL of the backend ECR repository"
  value       = var.enable_backend_repository ? aws_ecr_repository.backend[0].repository_url : null
}

output "backend_repository_arn" {
  description = "ARN of the backend ECR repository"
  value       = var.enable_backend_repository ? aws_ecr_repository.backend[0].arn : null
}

output "backend_repository_name" {
  description = "Name of the backend ECR repository"
  value       = var.enable_backend_repository ? aws_ecr_repository.backend[0].name : null
}

# All Repository URLs
output "repository_urls" {
  description = "Map of all repository URLs"
  value = {
    frontend = var.enable_frontend_repository ? aws_ecr_repository.frontend[0].repository_url : null
    backend  = var.enable_backend_repository ? aws_ecr_repository.backend[0].repository_url : null
  }
}

# ECR Summary
output "ecr_summary" {
  description = "Summary of the ECR infrastructure"
  value = {
    frontend_repository_enabled = var.enable_frontend_repository
    backend_repository_enabled  = var.enable_backend_repository
    image_scanning_enabled      = var.enable_image_scanning
    lifecycle_policies_enabled  = var.enable_lifecycle_policies
    max_image_count             = var.max_image_count
    frontend_repository_name    = var.enable_frontend_repository ? aws_ecr_repository.frontend[0].name : null
    backend_repository_name     = var.enable_backend_repository ? aws_ecr_repository.backend[0].name : null
  }
}
