# Encryption Module - Main Configuration
# This file creates comprehensive encryption infrastructure

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Generate names if not provided
  main_key_alias        = var.main_key_alias != "" ? var.main_key_alias : "alias/${var.project_name}-${var.environment}-key"
  application_key_alias = var.application_key_alias != "" ? var.application_key_alias : "alias/${var.project_name}-${var.environment}-app-key"
  database_key_alias    = var.database_key_alias != "" ? var.database_key_alias : "alias/${var.project_name}-${var.environment}-db-key"
  backup_key_alias      = var.backup_key_alias != "" ? var.backup_key_alias : "alias/${var.project_name}-${var.environment}-backup-key"

  # Generate descriptions if not provided
  main_key_description        = var.key_description != "" ? var.key_description : "Main encryption key for ${var.project_name} ${var.environment}"
  application_key_description = var.application_key_description != "" ? var.application_key_description : "Application encryption key for ${var.project_name} ${var.environment}"
  database_key_description    = var.database_key_description != "" ? var.database_key_description : "Database encryption key for ${var.project_name} ${var.environment}"
  backup_key_description      = var.backup_key_description != "" ? var.backup_key_description : "Backup encryption key for ${var.project_name} ${var.environment}"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Encryption and Key Management"
      ManagedBy   = "Terraform"
      Component   = "Encryption"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# MAIN ENCRYPTION KEY
# =============================================================================

# Main KMS Encryption Key
resource "aws_kms_key" "main" {
  count                   = var.enable_kms_encryption ? 1 : 0
  description             = local.main_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.key_rotation_enabled
  is_enabled              = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-main-key"
      Type = "Main Encryption"
    }
  )
}

# Main KMS Key Alias
resource "aws_kms_alias" "main" {
  count         = var.enable_kms_encryption ? 1 : 0
  name          = local.main_key_alias
  target_key_id = aws_kms_key.main[0].key_id
}

# =============================================================================
# APPLICATION ENCRYPTION KEY
# =============================================================================

# Application KMS Encryption Key
resource "aws_kms_key" "application" {
  count                   = var.enable_kms_encryption && var.enable_application_key ? 1 : 0
  description             = local.application_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.key_rotation_enabled
  is_enabled              = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-app-key"
      Type = "Application Encryption"
    }
  )
}

# Application KMS Key Alias
resource "aws_kms_alias" "application" {
  count         = var.enable_kms_encryption && var.enable_application_key ? 1 : 0
  name          = local.application_key_alias
  target_key_id = aws_kms_key.application[0].key_id
}

# =============================================================================
# DATABASE ENCRYPTION KEY
# =============================================================================

# Database KMS Encryption Key
resource "aws_kms_key" "database" {
  count                   = var.enable_kms_encryption && var.enable_database_key ? 1 : 0
  description             = local.database_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.key_rotation_enabled
  is_enabled              = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-key"
      Type = "Database Encryption"
    }
  )
}

# Database KMS Key Alias
resource "aws_kms_alias" "database" {
  count         = var.enable_kms_encryption && var.enable_database_key ? 1 : 0
  name          = local.database_key_alias
  target_key_id = aws_kms_key.database[0].key_id
}

# =============================================================================
# BACKUP ENCRYPTION KEY
# =============================================================================

# Backup KMS Encryption Key
resource "aws_kms_key" "backup" {
  count                   = var.enable_kms_encryption && var.enable_backup_key ? 1 : 0
  description             = local.backup_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.key_rotation_enabled
  is_enabled              = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backup-key"
      Type = "Backup Encryption"
    }
  )
}

# Backup KMS Key Alias
resource "aws_kms_alias" "backup" {
  count         = var.enable_kms_encryption && var.enable_backup_key ? 1 : 0
  name          = local.backup_key_alias
  target_key_id = aws_kms_key.backup[0].key_id
}
