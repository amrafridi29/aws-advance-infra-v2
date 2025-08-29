# Security Module - Main Configuration
# This file creates comprehensive security infrastructure

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
      Purpose     = "Security Infrastructure"
      ManagedBy   = "Terraform"
      Component   = "Security"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
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
