# IAM Module - Main Configuration
# This file creates comprehensive IAM infrastructure

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Generate names if not provided
  app_role_name     = var.app_role_name != "" ? var.app_role_name : "${var.project_name}-${var.environment}-app-role"
  admin_role_name   = var.admin_role_name != "" ? var.admin_role_name : "${var.project_name}-${var.environment}-admin-role"
  service_role_name = var.service_role_name != "" ? var.service_role_name : "${var.project_name}-${var.environment}-service-role"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Identity and Access Management"
      ManagedBy   = "Terraform"
      Component   = "IAM"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# IAM ROLES
# =============================================================================

# VPC Flow Log IAM Role
resource "aws_iam_role" "vpc_flow_log" {
  count = var.create_vpc_flow_log_role ? 1 : 0
  name  = "${local.name_prefix}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc-flow-log-role"
      Type = "VPC Flow Log"
    }
  )
}

# VPC Flow Log IAM Policy
resource "aws_iam_role_policy" "vpc_flow_log" {
  count = var.create_vpc_flow_log_role ? 1 : 0
  name  = "${local.name_prefix}-vpc-flow-log-policy"
  role  = aws_iam_role.vpc_flow_log[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# GitHub OIDC Identity Provider
resource "aws_iam_openid_connect_provider" "github" {
  count = var.enable_github_oidc ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-github-oidc-provider"
      Type = "OIDC Provider"
    }
  )
}

# GitHub Actions IAM Role
resource "aws_iam_role" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0
  name  = "${local.name_prefix}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" : concat(
              [for branch in var.allowed_branches : "repo:${var.frontend_repository}:ref:refs/heads/${branch}"],
              [for branch in var.allowed_branches : "repo:${var.backend_repository}:ref:refs/heads/${branch}"]
            )
          }
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-github-actions-role"
      Type = "GitHub Actions"
    }
  )
}

# GitHub Actions ECR Policy
resource "aws_iam_role_policy" "github_actions_ecr" {
  count = var.enable_github_oidc ? 1 : 0
  name  = "${local.name_prefix}-github-actions-ecr-policy"
  role  = aws_iam_role.github_actions[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:CreateRepository",
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
          "ecr:ListImages",
          "ecr:DeleteImage",
          "ecr:BatchDeleteImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# Application IAM Role
resource "aws_iam_role" "app" {
  count = var.create_app_role ? 1 : 0
  name  = local.app_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = local.app_role_name
      Type = "Application"
    }
  )
}

# Application IAM Policy
resource "aws_iam_role_policy" "app" {
  count = var.create_app_role ? 1 : 0
  name  = "${local.name_prefix}-app-policy"
  role  = aws_iam_role.app[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = length(var.app_role_s3_buckets) > 0 ? concat(
          [for bucket in var.app_role_s3_buckets : "arn:aws:s3:::${bucket}"],
          [for bucket in var.app_role_s3_buckets : "arn:aws:s3:::${bucket}/*"]
          ) : [
          "arn:aws:s3:::${var.project_name}-${var.environment}-*",
          "arn:aws:s3:::${var.project_name}-${var.environment}-*/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = length(var.app_role_kms_keys) > 0 ? var.app_role_kms_keys : ["*"]
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.${data.aws_region.current.name}.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Admin IAM Role (optional)
resource "aws_iam_role" "admin" {
  count = var.create_admin_role ? 1 : 0
  name  = local.admin_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.enable_cross_account_access ? concat(
            ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"],
            [for account_id in var.trusted_account_ids : "arn:aws:iam::${account_id}:root"]
          ) : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = local.admin_role_name
      Type = "Administrative"
    }
  )
}

# Admin IAM Policy
resource "aws_iam_role_policy" "admin" {
  count = var.create_admin_role ? 1 : 0
  name  = "${local.name_prefix}-admin-policy"
  role  = aws_iam_role.admin[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

# Service IAM Role (optional)
resource "aws_iam_role" "service" {
  count = var.create_service_role ? 1 : 0
  name  = local.service_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = local.service_role_name
      Type = "Service"
    }
  )
}

# ECS Task Execution IAM Role
resource "aws_iam_role" "ecs_task_execution" {
  count = var.create_ecs_task_execution_role ? 1 : 0
  name  = "${local.name_prefix}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecs-task-execution-role"
      Type = "ECS Task Execution"
    }
  )
}

# ECS Task Execution IAM Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count = var.create_ecs_task_execution_role ? 1 : 0

  role       = aws_iam_role.ecs_task_execution[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Execution SSM Parameter Access Policy
resource "aws_iam_role_policy" "ecs_task_execution_ssm" {
  count = var.create_ecs_task_execution_role ? 1 : 0
  name  = "${local.name_prefix}-ecs-task-execution-ssm-policy"
  role  = aws_iam_role.ecs_task_execution[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.environment}/*",
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.environment}/*"
        ]
      }
    ]
  })
}

# =============================================================================
# CUSTOM IAM POLICIES
# =============================================================================

# Custom IAM Policies
resource "aws_iam_policy" "custom" {
  for_each = var.custom_policies

  name        = "${local.name_prefix}-${each.key}-policy"
  description = each.value.description
  policy      = each.value.policy

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-policy"
      Type = "Custom Policy"
    }
  )
}
