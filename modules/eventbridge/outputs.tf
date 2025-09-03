# EventBridge Module - Outputs
# This file defines all outputs from the EventBridge module

# EventBridge Bus Outputs
output "event_bus_arn" {
  description = "ARN of the EventBridge bus"
  value       = var.enable_default_bus ? aws_cloudwatch_event_bus.default[0].arn : null
}

output "event_bus_name" {
  description = "Name of the EventBridge bus"
  value       = var.enable_default_bus ? aws_cloudwatch_event_bus.default[0].name : null
}

# ECR Scan Event Rule Outputs
output "ecr_scan_finding_rule_arn" {
  description = "ARN of the ECR scan finding event rule"
  value       = var.enable_ecr_scan_events ? aws_cloudwatch_event_rule.ecr_scan_finding[0].arn : null
}

output "ecr_scan_finding_rule_name" {
  description = "Name of the ECR scan finding event rule"
  value       = var.enable_ecr_scan_events ? aws_cloudwatch_event_rule.ecr_scan_finding[0].name : null
}

output "ecr_scan_complete_rule_arn" {
  description = "ARN of the ECR scan complete event rule"
  value       = var.enable_ecr_scan_events ? aws_cloudwatch_event_rule.ecr_scan_complete[0].arn : null
}

output "ecr_scan_complete_rule_name" {
  description = "Name of the ECR scan complete event rule"
  value       = var.enable_ecr_scan_events ? aws_cloudwatch_event_rule.ecr_scan_complete[0].name : null
}

# Event Target Outputs
output "ecr_scan_finding_target_id" {
  description = "ID of the ECR scan finding event target"
  value       = var.enable_ecr_scan_events && var.enable_sns_notifications ? aws_cloudwatch_event_target.ecr_scan_finding[0].target_id : null
}

output "ecr_scan_complete_target_id" {
  description = "ID of the ECR scan complete event target"
  value       = var.enable_ecr_scan_events && var.enable_sns_notifications ? aws_cloudwatch_event_target.ecr_scan_complete[0].target_id : null
}

# EventBridge Summary
output "eventbridge_summary" {
  description = "Summary of the EventBridge infrastructure"
  value = {
    default_bus_enabled         = var.enable_default_bus
    ecr_scan_events_enabled     = var.enable_ecr_scan_events
    sns_notifications_enabled   = var.enable_sns_notifications
    ecr_scan_finding_rule_name  = var.enable_ecr_scan_events ? aws_cloudwatch_event_rule.ecr_scan_finding[0].name : null
    ecr_scan_complete_rule_name = var.enable_ecr_scan_events ? aws_cloudwatch_event_rule.ecr_scan_complete[0].name : null
  }
}
