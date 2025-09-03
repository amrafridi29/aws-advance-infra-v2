# SNS Module - Outputs
# This file defines all outputs from the SNS module

# ECR Notifications Topic Outputs
output "ecr_notifications_topic_arn" {
  description = "ARN of the ECR notifications SNS topic"
  value       = var.enable_ecr_notifications ? aws_sns_topic.ecr_notifications[0].arn : null
}

output "ecr_notifications_topic_name" {
  description = "Name of the ECR notifications SNS topic"
  value       = var.enable_ecr_notifications ? aws_sns_topic.ecr_notifications[0].name : null
}

# ECR Security Alerts Topic Outputs
output "ecr_security_alerts_topic_arn" {
  description = "ARN of the ECR security alerts SNS topic"
  value       = var.enable_ecr_security_alerts ? aws_sns_topic.ecr_security_alerts[0].arn : null
}

output "ecr_security_alerts_topic_name" {
  description = "Name of the ECR security alerts SNS topic"
  value       = var.enable_ecr_security_alerts ? aws_sns_topic.ecr_security_alerts[0].name : null
}

# Email Subscription Outputs
output "ecr_notifications_subscriptions" {
  description = "List of ECR notifications email subscriptions"
  value = var.enable_ecr_notifications ? [
    for subscription in aws_sns_topic_subscription.ecr_notifications_email : subscription.endpoint
  ] : []
}

output "ecr_security_alerts_subscriptions" {
  description = "List of ECR security alerts email subscriptions"
  value = var.enable_ecr_security_alerts ? [
    for subscription in aws_sns_topic_subscription.ecr_security_alerts_email : subscription.endpoint
  ] : []
}

# SNS Summary
output "sns_summary" {
  description = "Summary of the SNS infrastructure"
  value = {
    ecr_notifications_enabled        = var.enable_ecr_notifications
    ecr_security_alerts_enabled      = var.enable_ecr_security_alerts
    ecr_notifications_topic_name     = var.enable_ecr_notifications ? aws_sns_topic.ecr_notifications[0].name : null
    ecr_security_alerts_topic_name   = var.enable_ecr_security_alerts ? aws_sns_topic.ecr_security_alerts[0].name : null
    notification_subscriptions_count = var.enable_ecr_notifications ? length(var.email_subscriptions) : 0
    security_subscriptions_count     = var.enable_ecr_security_alerts ? length(var.security_email_subscriptions) : 0
  }
}
