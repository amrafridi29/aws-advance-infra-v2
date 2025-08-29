# Encryption Module - Outputs
# This file defines all outputs from the encryption module

# Main Key Outputs
output "main_key_arn" {
  description = "ARN of the main KMS encryption key"
  value       = var.enable_kms_encryption ? aws_kms_key.main[0].arn : null
}

output "main_key_id" {
  description = "ID of the main KMS encryption key"
  value       = var.enable_kms_encryption ? aws_kms_key.main[0].key_id : null
}

output "main_key_alias" {
  description = "Alias of the main KMS encryption key"
  value       = var.enable_kms_encryption ? aws_kms_alias.main[0].name : null
}

# Application Key Outputs
output "application_key_arn" {
  description = "ARN of the application KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_application_key ? aws_kms_key.application[0].arn : null
}

output "application_key_id" {
  description = "ID of the application KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_application_key ? aws_kms_key.application[0].key_id : null
}

output "application_key_alias" {
  description = "Alias of the application KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_application_key ? aws_kms_alias.application[0].name : null
}

# Database Key Outputs
output "database_key_arn" {
  description = "ARN of the database KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_database_key ? aws_kms_key.database[0].arn : null
}

output "database_key_id" {
  description = "ID of the database KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_database_key ? aws_kms_key.database[0].key_id : null
}

output "database_key_alias" {
  description = "Alias of the database KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_database_key ? aws_kms_alias.database[0].name : null
}

# Backup Key Outputs
output "backup_key_arn" {
  description = "ARN of the backup KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_backup_key ? aws_kms_key.backup[0].arn : null
}

output "backup_key_id" {
  description = "ID of the backup KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_backup_key ? aws_kms_key.backup[0].key_id : null
}

output "backup_key_alias" {
  description = "Alias of the backup KMS encryption key"
  value       = var.enable_kms_encryption && var.enable_backup_key ? aws_kms_alias.backup[0].name : null
}

# All Key ARNs
output "all_key_arns" {
  description = "List of all KMS encryption key ARNs"
  value = compact([
    var.enable_kms_encryption ? aws_kms_key.main[0].arn : null,
    var.enable_kms_encryption && var.enable_application_key ? aws_kms_key.application[0].arn : null,
    var.enable_kms_encryption && var.enable_database_key ? aws_kms_key.database[0].arn : null,
    var.enable_kms_encryption && var.enable_backup_key ? aws_kms_key.backup[0].arn : null
  ])
}

# All Key Aliases
output "all_key_aliases" {
  description = "List of all KMS encryption key aliases"
  value = compact([
    var.enable_kms_encryption ? aws_kms_alias.main[0].name : null,
    var.enable_kms_encryption && var.enable_application_key ? aws_kms_alias.application[0].name : null,
    var.enable_kms_encryption && var.enable_database_key ? aws_kms_alias.database[0].name : null,
    var.enable_kms_encryption && var.enable_backup_key ? aws_kms_alias.backup[0].name : null
  ])
}

# Encryption Summary
output "encryption_summary" {
  description = "Summary of the encryption infrastructure"
  value = {
    main_key_enabled        = var.enable_kms_encryption
    application_key_enabled = var.enable_kms_encryption && var.enable_application_key
    database_key_enabled    = var.enable_kms_encryption && var.enable_database_key
    backup_key_enabled      = var.enable_kms_encryption && var.enable_backup_key
    key_rotation_enabled    = var.key_rotation_enabled
    multi_region_enabled    = var.enable_multi_region
    replica_regions         = var.replica_regions
  }
}
