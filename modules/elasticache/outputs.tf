# ElastiCache Module Outputs

output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].id : null
}

output "elasticache_endpoint" {
  description = "ElastiCache primary endpoint"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].primary_endpoint_address : null
}

output "elasticache_port" {
  description = "ElastiCache port"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].port : null
}

output "elasticache_reader_endpoint" {
  description = "ElastiCache reader endpoint (for read replicas)"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].reader_endpoint_address : null
}

output "elasticache_subnet_group_name" {
  description = "ElastiCache subnet group name"
  value       = var.enable_elasticache ? aws_elasticache_subnet_group.main[0].name : null
}

output "elasticache_parameter_group_name" {
  description = "ElastiCache parameter group name"
  value       = var.enable_elasticache ? aws_elasticache_parameter_group.main[0].name : null
}

output "elasticache_security_group_id" {
  description = "ElastiCache security group ID"
  value       = var.enable_elasticache ? aws_security_group.redis[0].id : null
}

output "elasticache_security_group_name" {
  description = "ElastiCache security group name"
  value       = var.enable_elasticache ? aws_security_group.redis[0].name : null
}

output "elasticache_arn" {
  description = "ElastiCache replication group ARN"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].arn : null
}

output "elasticache_member_clusters" {
  description = "List of ElastiCache cluster member IDs"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].member_clusters : []
}

output "elasticache_node_type" {
  description = "ElastiCache node type"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].node_type : null
}

output "elasticache_engine_version" {
  description = "ElastiCache engine version"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].engine_version : null
}

output "elasticache_multi_az_enabled" {
  description = "Whether Multi-AZ is enabled"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].automatic_failover_enabled : null
}

output "elasticache_snapshot_retention_limit" {
  description = "ElastiCache snapshot retention limit"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].snapshot_retention_limit : null
}

output "elasticache_snapshot_window" {
  description = "ElastiCache snapshot window"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].snapshot_window : null
}

output "elasticache_maintenance_window" {
  description = "ElastiCache maintenance window"
  value       = var.enable_elasticache ? aws_elasticache_replication_group.main[0].maintenance_window : null
}

output "elasticache_log_group_name" {
  description = "ElastiCache CloudWatch log group name"
  value       = var.enable_elasticache && var.enable_logging ? aws_cloudwatch_log_group.redis[0].name : null
}

output "elasticache_log_group_arn" {
  description = "ElastiCache CloudWatch log group ARN"
  value       = var.enable_elasticache && var.enable_logging ? aws_cloudwatch_log_group.redis[0].arn : null
}

output "elasticache_alarm_names" {
  description = "List of ElastiCache CloudWatch alarm names"
  value = var.enable_elasticache && var.enable_monitoring ? [
    aws_cloudwatch_metric_alarm.redis_cpu[0].alarm_name,
    aws_cloudwatch_metric_alarm.redis_memory[0].alarm_name,
    aws_cloudwatch_metric_alarm.redis_connections[0].alarm_name
  ] : []
}

output "elasticache_alarm_arns" {
  description = "List of ElastiCache CloudWatch alarm ARNs"
  value = var.enable_elasticache && var.enable_monitoring ? [
    aws_cloudwatch_metric_alarm.redis_cpu[0].arn,
    aws_cloudwatch_metric_alarm.redis_memory[0].arn,
    aws_cloudwatch_metric_alarm.redis_connections[0].arn
  ] : []
}

output "elasticache_connection_string" {
  description = "Redis connection string for applications"
  value = var.enable_elasticache ? (
    "redis://${aws_elasticache_replication_group.main[0].primary_endpoint_address}:${aws_elasticache_replication_group.main[0].port}"
  ) : null
}

output "elasticache_summary" {
  description = "Summary of ElastiCache configuration"
  value = {
    enabled                 = var.enable_elasticache
    cluster_id              = var.enable_elasticache ? aws_elasticache_replication_group.main[0].id : null
    endpoint                = var.enable_elasticache ? aws_elasticache_replication_group.main[0].primary_endpoint_address : null
    port                    = var.enable_elasticache ? aws_elasticache_replication_group.main[0].port : null
    node_type               = var.node_type
    engine_version          = var.redis_version
    multi_az_enabled        = var.multi_az_enabled
    snapshot_retention_days = var.snapshot_retention_days
    logging_enabled         = var.enable_logging
    monitoring_enabled      = var.enable_monitoring
    security_group_id       = var.enable_elasticache ? aws_security_group.redis[0].id : null
    subnet_group_name       = var.enable_elasticache ? aws_elasticache_subnet_group.main[0].name : null
    parameter_group_name    = var.enable_elasticache ? aws_elasticache_parameter_group.main[0].name : null
  }
}
