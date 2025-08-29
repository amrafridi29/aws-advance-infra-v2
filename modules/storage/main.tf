# Storage Module - Main Configuration
# This file creates comprehensive storage infrastructure

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Random password for RDS (when not provided)
resource "random_password" "db_password" {
  count   = var.enable_rds && var.rds_password == "" ? 1 : 0
  length  = 16
  special = true
}

# Local values for consistent naming and configuration
locals {
  # Generate bucket names if not provided
  s3_application_bucket_name   = var.s3_application_bucket_name != "" ? var.s3_application_bucket_name : "${var.project_name}-${var.environment}-app-data"
  s3_backup_bucket_name        = var.s3_backup_bucket_name != "" ? var.s3_backup_bucket_name : "${var.project_name}-${var.environment}-backups"
  s3_logs_bucket_name          = var.s3_logs_bucket_name != "" ? var.s3_logs_bucket_name : "${var.project_name}-${var.environment}-logs"
  s3_static_assets_bucket_name = var.s3_static_assets_bucket_name != "" ? var.s3_static_assets_bucket_name : "${var.project_name}-${var.environment}-static-assets"

  # Generate database name if not provided
  rds_database_name = var.rds_database_name != "" ? var.rds_database_name : "${replace(var.project_name, "-", "_")}_${var.environment}"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Storage Infrastructure"
      ManagedBy   = "Terraform"
      Component   = "Storage"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# S3 STORAGE INFRASTRUCTURE
# =============================================================================

# Application Data Bucket
resource "aws_s3_bucket" "application" {
  count  = var.enable_s3_storage ? 1 : 0
  bucket = local.s3_application_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-app-data-bucket"
      Type = "Application Data"
    }
  )
}

# Backup Bucket
resource "aws_s3_bucket" "backup" {
  count  = var.enable_s3_storage ? 1 : 0
  bucket = local.s3_backup_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backup-bucket"
      Type = "Backup Storage"
    }
  )
}

# Logs Bucket
resource "aws_s3_bucket" "logs" {
  count  = var.enable_s3_storage ? 1 : 0
  bucket = local.s3_logs_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-logs-bucket"
      Type = "Log Storage"
    }
  )
}

# Static Assets Bucket
resource "aws_s3_bucket" "static_assets" {
  count  = var.enable_s3_storage ? 1 : 0
  bucket = local.s3_static_assets_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-static-assets-bucket"
      Type = "Static Assets"
    }
  )
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "application" {
  count  = var.enable_s3_storage && var.s3_versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.application[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "backup" {
  count  = var.enable_s3_storage && var.s3_versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.backup[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "application" {
  count  = var.enable_s3_storage && var.s3_encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.application[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != "" ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn != "" ? var.kms_key_arn : null
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  count  = var.enable_s3_storage && var.s3_encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.backup[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != "" ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn != "" ? var.kms_key_arn : null
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "application" {
  count  = var.enable_s3_storage ? 1 : 0
  bucket = aws_s3_bucket.application[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "backup" {
  count  = var.enable_s3_storage ? 1 : 0
  bucket = aws_s3_bucket.backup[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Lifecycle Policies
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  count  = var.enable_s3_storage && var.s3_lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.logs[0].id

  rule {
    id     = "log_lifecycle"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# =============================================================================
# RDS DATABASE INFRASTRUCTURE
# =============================================================================

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  count      = var.enable_rds ? 1 : 0
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-subnet-group"
      Type = "Database Subnet Group"
    }
  )
}

# RDS Parameter Group
resource "aws_db_parameter_group" "main" {
  count  = var.enable_rds ? 1 : 0
  family = var.rds_engine == "mysql" ? "mysql8.0" : "${var.rds_engine}${var.rds_engine_version}"

  name = "${local.name_prefix}-db-params"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-params"
      Type = "Database Parameters"
    }
  )
}

# RDS Instance
resource "aws_db_instance" "main" {
  count = var.enable_rds ? 1 : 0

  identifier = "${local.name_prefix}-db"

  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_allocated_storage * 2

  db_name  = local.rds_database_name
  username = var.rds_username
  password = var.rds_password != "" ? var.rds_password : random_password.db_password[0].result

  vpc_security_group_ids = var.database_security_group_id != "" ? [var.database_security_group_id] : []
  db_subnet_group_name   = aws_db_subnet_group.main[0].name
  parameter_group_name   = aws_db_parameter_group.main[0].name

  multi_az                = var.rds_multi_az
  backup_retention_period = var.rds_backup_retention
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  storage_encrypted = var.kms_key_arn != ""
  kms_key_id        = var.kms_key_arn != "" ? var.kms_key_arn : null

  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.name_prefix}-db-final-snapshot"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db"
      Type = "Database Instance"
    }
  )
}

# =============================================================================
# ELASTICACHE INFRASTRUCTURE
# =============================================================================

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  count      = var.enable_elasticache ? 1 : 0
  name       = "${local.name_prefix}-cache-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cache-subnet-group"
      Type = "Cache Subnet Group"
    }
  )
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  count  = var.enable_elasticache ? 1 : 0
  family = var.elasticache_engine == "redis" ? "redis7" : "memcached1.6"

  name = "${local.name_prefix}-cache-params"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cache-params"
      Type = "Cache Parameters"
    }
  )
}

# ElastiCache Cluster
resource "aws_elasticache_cluster" "main" {
  count = var.enable_elasticache ? 1 : 0

  cluster_id           = "${local.name_prefix}-cache"
  engine               = var.elasticache_engine
  node_type            = var.elasticache_node_type
  num_cache_nodes      = var.elasticache_cluster_size
  parameter_group_name = aws_elasticache_parameter_group.main[0].name
  subnet_group_name    = aws_elasticache_subnet_group.main[0].name
  port                 = var.elasticache_port

  security_group_ids = var.cache_security_group_id != "" ? [var.cache_security_group_id] : []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cache"
      Type = "Cache Cluster"
    }
  )
}

# =============================================================================
# EBS VOLUME INFRASTRUCTURE
# =============================================================================

# EBS Volumes
resource "aws_ebs_volume" "application" {
  count             = var.enable_ebs ? 1 : 0
  availability_zone = data.aws_region.current.name
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  encrypted         = var.kms_key_arn != ""
  kms_key_id        = var.kms_key_arn != "" ? var.kms_key_arn : null

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-app-volume"
      Type = "Application Volume"
    }
  )
}

resource "aws_ebs_volume" "database" {
  count             = var.enable_ebs ? 1 : 0
  availability_zone = data.aws_region.current.name
  size              = var.ebs_volume_size * 2
  type              = var.ebs_volume_type
  encrypted         = var.kms_key_arn != ""
  kms_key_id        = var.kms_key_arn != "" ? var.kms_key_arn : null

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-volume"
      Type = "Database Volume"
    }
  )
}
