# Storage Module - Outputs
# This file defines all outputs from the storage module

# S3 Storage Outputs
output "s3_bucket_names" {
  description = "List of S3 bucket names"
  value = compact([
    var.enable_s3_storage ? aws_s3_bucket.application[0].bucket : null,
    var.enable_s3_storage ? aws_s3_bucket.backup[0].bucket : null,
    var.enable_s3_storage ? aws_s3_bucket.logs[0].bucket : null,
    var.enable_s3_storage ? aws_s3_bucket.static_assets[0].bucket : null
  ])
}

output "s3_bucket_arns" {
  description = "List of S3 bucket ARNs"
  value = compact([
    var.enable_s3_storage ? aws_s3_bucket.application[0].arn : null,
    var.enable_s3_storage ? aws_s3_bucket.backup[0].arn : null,
    var.enable_s3_storage ? aws_s3_bucket.logs[0].arn : null,
    var.enable_s3_storage ? aws_s3_bucket.static_assets[0].arn : null
  ])
}

output "application_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = var.enable_s3_storage ? aws_s3_bucket.application[0].bucket : null
}

output "backup_bucket_name" {
  description = "Name of the backup S3 bucket"
  value       = var.enable_s3_storage ? aws_s3_bucket.backup[0].bucket : null
}

output "logs_bucket_name" {
  description = "Name of the logs S3 bucket"
  value       = var.enable_s3_storage ? aws_s3_bucket.logs[0].bucket : null
}

output "static_assets_bucket_name" {
  description = "Name of the static assets S3 bucket"
  value       = var.enable_s3_storage ? aws_s3_bucket.static_assets[0].bucket : null
}

# RDS Database Outputs
output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = var.enable_rds ? aws_db_instance.main[0].endpoint : null
}

output "rds_identifier" {
  description = "RDS database identifier"
  value       = var.enable_rds ? aws_db_instance.main[0].identifier : null
}

output "rds_arn" {
  description = "RDS database ARN"
  value       = var.enable_rds ? aws_db_instance.main[0].arn : null
}

output "rds_subnet_group_name" {
  description = "RDS subnet group name"
  value       = var.enable_rds ? aws_db_subnet_group.main[0].name : null
}

output "rds_parameter_group_name" {
  description = "RDS parameter group name"
  value       = var.enable_rds ? aws_db_parameter_group.main[0].name : null
}

# ElastiCache Outputs
output "elasticache_endpoint" {
  description = "ElastiCache endpoint"
  value       = var.enable_elasticache ? aws_elasticache_cluster.main[0].cache_nodes[0].address : null
}

output "elasticache_port" {
  description = "ElastiCache port"
  value       = var.enable_elasticache ? aws_elasticache_cluster.main[0].port : null
}

output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = var.enable_elasticache ? aws_elasticache_cluster.main[0].cluster_id : null
}

output "elasticache_subnet_group_name" {
  description = "ElastiCache subnet group name"
  value       = var.enable_elasticache ? aws_elasticache_subnet_group.main[0].name : null
}

# EBS Volume Outputs
output "ebs_volume_ids" {
  description = "List of EBS volume IDs"
  value = compact([
    var.enable_ebs ? aws_ebs_volume.application[0].id : null,
    var.enable_ebs ? aws_ebs_volume.database[0].id : null
  ])
}

output "application_volume_id" {
  description = "ID of the application EBS volume"
  value       = var.enable_ebs ? aws_ebs_volume.application[0].id : null
}

output "database_volume_id" {
  description = "ID of the database EBS volume"
  value       = var.enable_ebs ? aws_ebs_volume.database[0].id : null
}

# Storage Summary
output "storage_summary" {
  description = "Summary of the storage infrastructure"
  value = {
    s3_storage_enabled       = var.enable_s3_storage
    rds_enabled              = var.enable_rds
    elasticache_enabled      = var.enable_elasticache
    ebs_enabled              = var.enable_ebs
    s3_lifecycle_enabled     = var.s3_lifecycle_enabled
    s3_versioning_enabled    = var.s3_versioning_enabled
    s3_encryption_enabled    = var.s3_encryption_enabled
    rds_multi_az             = var.enable_rds ? var.rds_multi_az : false
    rds_backup_retention     = var.enable_rds ? var.rds_backup_retention : 0
    elasticache_engine       = var.enable_elasticache ? var.elasticache_engine : null
    elasticache_cluster_size = var.enable_elasticache ? var.elasticache_cluster_size : 0
    kms_encryption_enabled   = var.kms_key_arn != ""
  }
}
