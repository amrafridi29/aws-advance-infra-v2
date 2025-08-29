# Security Module - Outputs
# This file defines all outputs from the security module

# IAM Role Outputs
output "vpc_flow_log_role_arn" {
  description = "ARN of the VPC Flow Log IAM role"
  value       = var.create_vpc_flow_log_role ? aws_iam_role.vpc_flow_log[0].arn : null
}

output "app_role_arn" {
  description = "ARN of the application IAM role"
  value       = var.create_app_role ? aws_iam_role.app[0].arn : null
}

output "admin_role_arn" {
  description = "ARN of the admin IAM role"
  value       = var.create_admin_role ? aws_iam_role.admin[0].arn : null
}

output "vpc_flow_log_role_name" {
  description = "Name of the VPC Flow Log IAM role"
  value       = var.create_vpc_flow_log_role ? aws_iam_role.vpc_flow_log[0].name : null
}

output "app_role_name" {
  description = "Name of the application IAM role"
  value       = var.create_app_role ? aws_iam_role.app[0].name : null
}

output "admin_role_name" {
  description = "Name of the admin IAM role"
  value       = var.create_admin_role ? aws_iam_role.admin[0].name : null
}

# KMS Outputs
output "kms_key_arn" {
  description = "ARN of the KMS encryption key"
  value       = var.enable_kms_encryption ? aws_kms_key.main[0].arn : null
}

output "kms_key_id" {
  description = "ID of the KMS encryption key"
  value       = var.enable_kms_encryption ? aws_kms_key.main[0].key_id : null
}

output "kms_key_alias" {
  description = "Alias of the KMS encryption key"
  value       = var.enable_kms_encryption ? aws_kms_alias.main[0].name : null
}

# Security Group Outputs
output "app_security_group_id" {
  description = "ID of the application security group"
  value       = var.create_security_groups ? aws_security_group.app[0].id : null
}

output "app_security_group_name" {
  description = "Name of the application security group"
  value       = var.create_security_groups ? aws_security_group.app[0].name : null
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = var.create_security_groups && var.enable_database_access ? aws_security_group.database[0].id : null
}

output "database_security_group_name" {
  description = "Name of the database security group"
  value       = var.create_security_groups && var.enable_database_access ? aws_security_group.database[0].name : null
}

output "load_balancer_security_group_id" {
  description = "ID of the load balancer security group"
  value       = var.create_security_groups ? aws_security_group.load_balancer[0].id : null
}

output "load_balancer_security_group_name" {
  description = "Name of the load balancer security group"
  value       = var.create_security_groups ? aws_security_group.load_balancer[0].name : null
}

output "security_group_ids" {
  description = "List of all security group IDs"
  value = compact([
    var.create_security_groups ? aws_security_group.app[0].id : null,
    var.create_security_groups && var.enable_database_access ? aws_security_group.database[0].id : null,
    var.create_security_groups ? aws_security_group.load_balancer[0].id : null
  ])
}

# Security Summary
output "security_summary" {
  description = "Summary of the security infrastructure"
  value = {
    vpc_flow_log_role_created = var.create_vpc_flow_log_role
    app_role_created          = var.create_app_role
    admin_role_created        = var.create_admin_role
    kms_encryption_enabled    = var.enable_kms_encryption
    security_groups_created   = var.create_security_groups
    database_access_enabled   = var.enable_database_access
    http_access_enabled       = var.enable_http_access
    https_access_enabled      = var.enable_https_access
    ssh_access_enabled        = var.enable_ssh_access
  }
}
