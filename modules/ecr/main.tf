# ECR Module - Main Configuration
# This file creates ECR repositories for container images

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Container Registry"
      ManagedBy   = "Terraform"
      Component   = "ECR"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# ECR REPOSITORIES
# =============================================================================

# Frontend ECR Repository
resource "aws_ecr_repository" "frontend" {
  count = var.enable_frontend_repository ? 1 : 0

  name                 = "${local.name_prefix}-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.enable_image_scanning
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-frontend"
      Type = "Frontend Repository"
    }
  )
}

# Backend ECR Repository
resource "aws_ecr_repository" "backend" {
  count = var.enable_backend_repository ? 1 : 0

  name                 = "${local.name_prefix}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.enable_image_scanning
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backend"
      Type = "Backend Repository"
    }
  )
}

# =============================================================================
# ECR LIFECYCLE POLICIES
# =============================================================================

# Frontend Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "frontend" {
  count = var.enable_frontend_repository && var.enable_lifecycle_policies ? 1 : 0

  repository = aws_ecr_repository.frontend[0].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Backend Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "backend" {
  count = var.enable_backend_repository && var.enable_lifecycle_policies ? 1 : 0

  repository = aws_ecr_repository.backend[0].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
