# Compute Module - Outputs
# This file defines all outputs from the compute module

# ECS Cluster Outputs
output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = var.enable_ecs ? aws_ecs_cluster.main[0].arn : null
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = var.enable_ecs ? aws_ecs_cluster.main[0].name : null
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = var.enable_ecs ? aws_ecs_cluster.main[0].id : null
}



# ECS Service Outputs
output "ecs_service_arn" {
  description = "ARN of the ECS service"
  value       = var.enable_ecs && var.enable_ecs_service ? aws_ecs_service.main[0].id : null
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = var.enable_ecs && var.enable_ecs_service ? aws_ecs_service.main[0].name : null
}

# ECS Task Definition Outputs
output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = var.enable_ecs && var.enable_ecs_service ? aws_ecs_task_definition.main[0].arn : null
}

output "ecs_task_definition_family" {
  description = "Family name of the ECS task definition"
  value       = var.enable_ecs && var.enable_ecs_service ? aws_ecs_task_definition.main[0].family : null
}

# Service Discovery Outputs
output "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  value       = var.enable_service_discovery ? aws_service_discovery_private_dns_namespace.main[0].id : null
}

output "service_discovery_namespace_name" {
  description = "Name of the service discovery namespace"
  value       = var.enable_service_discovery ? aws_service_discovery_private_dns_namespace.main[0].name : null
}

output "service_discovery_service_arn" {
  description = "ARN of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.main[0].arn : null
}

output "service_discovery_service_name" {
  description = "Name of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.main[0].name : null
}

# Auto Scaling Outputs
output "auto_scaling_target_arn" {
  description = "ARN of the auto scaling target"
  value       = var.enable_auto_scaling && var.enable_ecs_service ? aws_appautoscaling_target.ecs_target[0].resource_id : null
}

output "auto_scaling_policy_arns" {
  description = "List of auto scaling policy ARNs"
  value = compact([
    var.enable_auto_scaling && var.enable_ecs_service ? aws_appautoscaling_policy.ecs_cpu_policy[0].arn : null,
    var.enable_auto_scaling && var.enable_ecs_service ? aws_appautoscaling_policy.ecs_memory_policy[0].arn : null
  ])
}



# Compute Summary
output "compute_summary" {
  description = "Summary of the compute infrastructure"
  value = {
    ecs_enabled                 = var.enable_ecs
    ecs_service_enabled         = var.enable_ecs && var.enable_ecs_service
    service_discovery_enabled   = var.enable_service_discovery
    auto_scaling_enabled        = var.enable_auto_scaling && var.enable_ecs_service
    ecs_cluster_name            = var.enable_ecs ? aws_ecs_cluster.main[0].name : null
    ecs_service_name            = var.enable_ecs && var.enable_ecs_service ? aws_ecs_service.main[0].name : null
    service_discovery_namespace = var.enable_service_discovery ? aws_service_discovery_private_dns_namespace.main[0].name : null
  }
}
