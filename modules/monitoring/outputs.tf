# Monitoring Module - Outputs
# This file defines all outputs from the monitoring module

# VPC Flow Logs Outputs
output "vpc_flow_log_ids" {
  description = "List of VPC Flow Log IDs"
  value       = aws_flow_log.vpc_flow_log[*].id
}

output "flow_log_group_names" {
  description = "List of CloudWatch Log Group names for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_log[*].name
}

# CloudWatch Log Groups Outputs
output "application_log_group_names" {
  description = "List of application log group names"
  value       = aws_cloudwatch_log_group.application[*].name
}

output "system_log_group_names" {
  description = "List of system log group names"
  value       = aws_cloudwatch_log_group.system[*].name
}

output "security_log_group_names" {
  description = "List of security log group names"
  value       = aws_cloudwatch_log_group.security[*].name
}

output "all_log_group_names" {
  description = "List of all CloudWatch log group names"
  value = compact(concat(
    aws_cloudwatch_log_group.application[*].name,
    aws_cloudwatch_log_group.system[*].name,
    aws_cloudwatch_log_group.security[*].name,
    aws_cloudwatch_log_group.vpc_flow_log[*].name
  ))
}

# CloudTrail Outputs
output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = var.enable_cloudtrail ? aws_cloudtrail.main[0].arn : null
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail trail"
  value       = var.enable_cloudtrail ? aws_cloudtrail.main[0].name : null
}

output "cloudtrail_log_group_name" {
  description = "Name of the CloudTrail log group"
  value       = var.enable_cloudtrail ? aws_cloudwatch_log_group.cloudtrail[0].name : null
}

# SNS Outputs
output "sns_topic_arn" {
  description = "ARN of the SNS notification topic"
  value       = var.create_sns_topic ? aws_sns_topic.notifications[0].arn : null
}

output "sns_topic_name" {
  description = "Name of the SNS notification topic"
  value       = var.create_sns_topic ? aws_sns_topic.notifications[0].name : null
}

# CloudWatch Alarms Outputs
output "cpu_alarm_name" {
  description = "Name of the CPU utilization alarm"
  value       = var.enable_alarms ? aws_cloudwatch_metric_alarm.cpu_high[0].alarm_name : null
}

output "memory_alarm_name" {
  description = "Name of the memory utilization alarm"
  value       = var.enable_alarms ? aws_cloudwatch_metric_alarm.memory_high[0].alarm_name : null
}

output "alarm_names" {
  description = "List of all CloudWatch alarm names"
  value = compact([
    var.enable_alarms ? aws_cloudwatch_metric_alarm.cpu_high[0].alarm_name : null,
    var.enable_alarms ? aws_cloudwatch_metric_alarm.memory_high[0].alarm_name : null
  ])
}

# CloudWatch Dashboards Outputs
output "overview_dashboard_name" {
  description = "Name of the overview dashboard"
  value       = var.enable_dashboards ? aws_cloudwatch_dashboard.overview[0].dashboard_name : null
}

output "dashboard_names" {
  description = "List of all CloudWatch dashboard names"
  value = compact([
    var.enable_dashboards ? aws_cloudwatch_dashboard.overview[0].dashboard_name : null
  ])
}

# ECS Log Group Outputs
output "ecs_log_group_names" {
  description = "List of ECS log group names"
  value       = var.enable_ecs_log_groups ? [for lg in aws_cloudwatch_log_group.ecs : lg.name] : []
}

# EventBridge Outputs
output "eventbridge_outputs" {
  description = "EventBridge module outputs"
  value       = module.eventbridge
}

# SNS Outputs
output "sns_outputs" {
  description = "SNS module outputs"
  value       = module.sns
}

# ECR Notification Outputs
output "ecr_notifications_topic_arn" {
  description = "ARN of the ECR notifications SNS topic"
  value       = var.enable_ecr_scan_events ? module.sns.ecr_notifications_topic_arn : null
}

output "ecr_security_alerts_topic_arn" {
  description = "ARN of the ECR security alerts SNS topic"
  value       = var.enable_ecr_scan_events ? module.sns.ecr_security_alerts_topic_arn : null
}

output "ecr_scan_finding_rule_arn" {
  description = "ARN of the ECR scan finding event rule"
  value       = var.enable_ecr_scan_events ? module.eventbridge.ecr_scan_finding_rule_arn : null
}

output "ecr_scan_complete_rule_arn" {
  description = "ARN of the ECR scan complete event rule"
  value       = var.enable_ecr_scan_events ? module.eventbridge.ecr_scan_complete_rule_arn : null
}

# Monitoring Summary
output "monitoring_summary" {
  description = "Summary of the monitoring infrastructure"
  value = {
    vpc_flow_logs_enabled     = var.enable_vpc_flow_logs
    cloudwatch_logs_enabled   = var.enable_cloudwatch_logs
    cloudtrail_enabled        = var.enable_cloudtrail
    alarms_enabled            = var.enable_alarms
    dashboards_enabled        = var.enable_dashboards
    ecs_log_groups_enabled    = var.enable_ecs_log_groups
    sns_topic_created         = var.create_sns_topic
    flow_log_retention_days   = var.flow_log_retention_days
    log_retention_days        = var.log_retention_days
    cloudtrail_retention_days = var.cloudtrail_retention_days
  }
}
