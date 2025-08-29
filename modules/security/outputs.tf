# Security Module - Outputs
# This file defines all outputs from the security module

# IAM and KMS outputs are now provided by dedicated modules

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

output "default_security_group_id" {
  description = "ID of the default security group"
  value       = var.create_security_groups ? aws_security_group.default[0].id : null
}

output "default_security_group_name" {
  description = "Name of the default security group"
  value       = var.create_security_groups ? aws_security_group.default[0].name : null
}

output "load_balancer_security_group_name" {
  description = "Name of the load balancer security group"
  value       = var.create_security_groups ? aws_security_group.load_balancer[0].name : null
}

output "security_group_ids" {
  description = "List of all security group IDs"
  value = compact([
    var.create_security_groups ? aws_security_group.default[0].id : null,
    var.create_security_groups ? aws_security_group.app[0].id : null,
    var.create_security_groups && var.enable_database_access ? aws_security_group.database[0].id : null,
    var.create_security_groups ? aws_security_group.load_balancer[0].id : null
  ])
}

# Security Summary
output "security_summary" {
  description = "Summary of the security infrastructure"
  value = {
    security_groups_created = var.create_security_groups
    database_access_enabled = var.enable_database_access
    http_access_enabled     = var.enable_http_access
    https_access_enabled    = var.enable_https_access
    ssh_access_enabled      = var.enable_ssh_access
  }
}
