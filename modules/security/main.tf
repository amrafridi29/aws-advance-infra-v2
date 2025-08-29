# Security Module - Main Configuration
# This file creates comprehensive security infrastructure

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Generate names if not provided
  admin_role_name = var.admin_role_name != "" ? var.admin_role_name : "${var.project_name}-${var.environment}-admin-role"
  app_role_name   = var.app_role_name != "" ? var.app_role_name : "${var.project_name}-${var.environment}-app-role"
  kms_key_alias   = var.kms_key_alias != "" ? var.kms_key_alias : "alias/${var.project_name}-${var.environment}-key"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Security Infrastructure"
      ManagedBy   = "Terraform"
      Component   = "Security"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# IAM ROLES AND POLICIES
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
        Resource = [
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
        Resource = "*"
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
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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

# =============================================================================
# KMS ENCRYPTION
# =============================================================================

# KMS Encryption Key
resource "aws_kms_key" "main" {
  count                   = var.enable_kms_encryption ? 1 : 0
  description             = var.kms_key_description != "" ? var.kms_key_description : "Encryption key for ${var.project_name} ${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = var.key_rotation_enabled

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-encryption-key"
      Type = "Encryption"
    }
  )
}

# KMS Key Alias
resource "aws_kms_alias" "main" {
  count         = var.enable_kms_encryption ? 1 : 0
  name          = local.kms_key_alias
  target_key_id = aws_kms_key.main[0].key_id
}

# =============================================================================
# SECURITY GROUPS
# =============================================================================

# Application Security Group
resource "aws_security_group" "app" {
  count       = var.create_security_groups ? 1 : 0
  name_prefix = "${local.name_prefix}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  # Inbound rules
  dynamic "ingress" {
    for_each = var.enable_http_access ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "HTTP access"
    }
  }

  dynamic "ingress" {
    for_each = var.enable_https_access ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "HTTPS access"
    }
  }

  dynamic "ingress" {
    for_each = var.enable_ssh_access ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "SSH access"
    }
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-app-sg"
      Type = "Application"
    }
  )
}

# Database Security Group
resource "aws_security_group" "database" {
  count       = var.create_security_groups && var.enable_database_access ? 1 : 0
  name_prefix = "${local.name_prefix}-db-sg"
  description = "Security group for database instances"
  vpc_id      = var.vpc_id

  # Inbound rules - only from application security group
  ingress {
    from_port       = var.database_port
    to_port         = var.database_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app[0].id]
    description     = "Database access from application"
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-sg"
      Type = "Database"
    }
  )
}

# Default Security Group for VPC
resource "aws_security_group" "default" {
  count       = var.create_security_groups ? 1 : 0
  name_prefix = "${local.name_prefix}-default-sg"
  description = "Default security group for VPC"
  vpc_id      = var.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-default-sg"
      Type = "Default"
    }
  )
}

# Load Balancer Security Group
resource "aws_security_group" "load_balancer" {
  count       = var.create_security_groups ? 1 : 0
  name_prefix = "${local.name_prefix}-lb-sg"
  description = "Security group for load balancers"
  vpc_id      = var.vpc_id

  # Inbound rules
  dynamic "ingress" {
    for_each = var.enable_http_access ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "HTTP access"
    }
  }

  dynamic "ingress" {
    for_each = var.enable_https_access ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "HTTPS access"
    }
  }

  # Outbound rules
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.app[0].id]
    description     = "All outbound traffic to application"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-lb-sg"
      Type = "Load Balancer"
    }
  )
}
