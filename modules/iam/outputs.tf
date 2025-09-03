# IAM Module - Outputs
# This file defines all outputs from the IAM module

# IAM Role Outputs
output "vpc_flow_log_role_arn" {
  description = "ARN of the VPC Flow Log IAM role"
  value       = var.create_vpc_flow_log_role ? aws_iam_role.vpc_flow_log[0].arn : null
}

output "vpc_flow_log_role_name" {
  description = "Name of the VPC Flow Log IAM role"
  value       = var.create_vpc_flow_log_role ? aws_iam_role.vpc_flow_log[0].name : null
}

output "app_role_arn" {
  description = "ARN of the application IAM role"
  value       = var.create_app_role ? aws_iam_role.app[0].arn : null
}

output "app_role_name" {
  description = "Name of the application IAM role"
  value       = var.create_app_role ? aws_iam_role.app[0].name : null
}

output "admin_role_arn" {
  description = "ARN of the admin IAM role"
  value       = var.create_admin_role ? aws_iam_role.admin[0].arn : null
}

output "admin_role_name" {
  description = "Name of the admin IAM role"
  value       = var.create_admin_role ? aws_iam_role.admin[0].name : null
}

output "service_role_arn" {
  description = "ARN of the service IAM role"
  value       = var.create_service_role ? aws_iam_role.service[0].arn : null
}

output "service_role_name" {
  description = "Name of the service IAM role"
  value       = var.create_service_role ? aws_iam_role.service[0].name : null
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  value       = var.create_ecs_task_execution_role ? aws_iam_role.ecs_task_execution[0].arn : null
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution IAM role"
  value       = var.create_ecs_task_execution_role ? aws_iam_role.ecs_task_execution[0].name : null
}

# All Role ARNs
output "all_role_arns" {
  description = "List of all IAM role ARNs"
  value = compact([
    var.create_vpc_flow_log_role ? aws_iam_role.vpc_flow_log[0].arn : null,
    var.create_app_role ? aws_iam_role.app[0].arn : null,
    var.create_admin_role ? aws_iam_role.admin[0].arn : null,
    var.create_service_role ? aws_iam_role.service[0].arn : null,
    var.create_ecs_task_execution_role ? aws_iam_role.ecs_task_execution[0].arn : null,
    var.enable_github_oidc ? aws_iam_role.github_actions[0].arn : null
  ])
}

# Custom Policy Outputs
output "custom_policy_arns" {
  description = "List of custom IAM policy ARNs"
  value       = [for policy in aws_iam_policy.custom : policy.arn]
}

output "custom_policy_names" {
  description = "List of custom IAM policy names"
  value       = [for policy in aws_iam_policy.custom : policy.name]
}

# GitHub OIDC Outputs
output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role"
  value       = var.enable_github_oidc ? aws_iam_role.github_actions[0].arn : null
}

output "github_actions_role_name" {
  description = "Name of the GitHub Actions IAM role"
  value       = var.enable_github_oidc ? aws_iam_role.github_actions[0].name : null
}

# IAM Summary
output "iam_summary" {
  description = "Summary of the IAM infrastructure"
  value = {
    vpc_flow_log_role_created       = var.create_vpc_flow_log_role
    app_role_created                = var.create_app_role
    admin_role_created              = var.create_admin_role
    service_role_created            = var.create_service_role
    ecs_task_execution_role_created = var.create_ecs_task_execution_role
    custom_policies_created         = length(var.custom_policies)
    cross_account_enabled           = var.enable_cross_account_access
    trusted_accounts                = var.trusted_account_ids
    github_oidc_enabled             = var.enable_github_oidc
    frontend_repository             = var.frontend_repository
    backend_repository              = var.backend_repository
    allowed_branches                = var.allowed_branches
  }
}
