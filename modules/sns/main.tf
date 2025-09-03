# SNS Module - Main Configuration
# This file creates SNS topics and subscriptions for ECR scan notifications

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Notifications"
      ManagedBy   = "Terraform"
      Component   = "SNS"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# SNS TOPICS
# =============================================================================

# ECR Notifications Topic
resource "aws_sns_topic" "ecr_notifications" {
  count = var.enable_ecr_notifications ? 1 : 0

  name = "${local.name_prefix}-ecr-notifications"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecr-notifications"
      Type = "ECR Notifications"
    }
  )
}

# ECR Security Alerts Topic
resource "aws_sns_topic" "ecr_security_alerts" {
  count = var.enable_ecr_security_alerts ? 1 : 0

  name = "${local.name_prefix}-ecr-security-alerts"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecr-security-alerts"
      Type = "ECR Security Alerts"
    }
  )
}

# =============================================================================
# SNS SUBSCRIPTIONS
# =============================================================================

# Email Subscriptions for ECR Notifications
resource "aws_sns_topic_subscription" "ecr_notifications_email" {
  for_each = var.enable_ecr_notifications ? toset(var.email_subscriptions) : toset([])

  topic_arn = aws_sns_topic.ecr_notifications[0].arn
  protocol  = "email"
  endpoint  = each.value
}

# Email Subscriptions for ECR Security Alerts
resource "aws_sns_topic_subscription" "ecr_security_alerts_email" {
  for_each = var.enable_ecr_security_alerts ? toset(var.security_email_subscriptions) : toset([])

  topic_arn = aws_sns_topic.ecr_security_alerts[0].arn
  protocol  = "email"
  endpoint  = each.value
}

# =============================================================================
# SNS TOPIC POLICIES
# =============================================================================

# ECR Notifications Topic Policy
resource "aws_sns_topic_policy" "ecr_notifications" {
  count = var.enable_ecr_notifications ? 1 : 0

  arn = aws_sns_topic.ecr_notifications[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEventBridgePublish"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ecr_notifications[0].arn
      },
      {
        Sid    = "AllowCloudWatchPublish"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ecr_notifications[0].arn
      }
    ]
  })
}

# ECR Security Alerts Topic Policy
resource "aws_sns_topic_policy" "ecr_security_alerts" {
  count = var.enable_ecr_security_alerts ? 1 : 0

  arn = aws_sns_topic.ecr_security_alerts[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEventBridgePublish"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ecr_security_alerts[0].arn
      },
      {
        Sid    = "AllowCloudWatchPublish"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ecr_security_alerts[0].arn
      }
    ]
  })
}
