# Monitoring Module - Main Configuration
# This file creates comprehensive monitoring and observability infrastructure

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Generate names if not provided
  cloudtrail_log_group_name = var.cloudtrail_log_group_name != "" ? var.cloudtrail_log_group_name : "/aws/cloudtrail/${var.project_name}-${var.environment}"
  sns_topic_name            = var.sns_topic_name != "" ? var.sns_topic_name : "${var.project_name}-${var.environment}-notifications"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Monitoring and Observability"
      ManagedBy   = "Terraform"
      Component   = "Monitoring"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# CLOUDWATCH LOG GROUPS
# =============================================================================

# Application Log Group
resource "aws_cloudwatch_log_group" "application" {
  count             = var.enable_cloudwatch_logs && var.create_application_log_group ? 1 : 0
  name              = "/aws/${var.project_name}/${var.environment}/application"
  retention_in_days = var.log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-app-logs"
      Type = "Application"
    }
  )
}

# System Log Group
resource "aws_cloudwatch_log_group" "system" {
  count             = var.enable_cloudwatch_logs && var.create_system_log_group ? 1 : 0
  name              = "/aws/${var.project_name}/${var.environment}/system"
  retention_in_days = var.log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-system-logs"
      Type = "System"
    }
  )
}

# Security Log Group
resource "aws_cloudwatch_log_group" "security" {
  count             = var.enable_cloudwatch_logs && var.create_security_log_group ? 1 : 0
  name              = "/aws/${var.project_name}/${var.environment}/security"
  retention_in_days = var.log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-security-logs"
      Type = "Security"
    }
  )
}

# =============================================================================
# VPC FLOW LOGS
# =============================================================================

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count             = var.enable_vpc_flow_logs ? 1 : 0
  name              = "/aws/vpc/flow-logs/${var.vpc_id}"
  retention_in_days = var.flow_log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc-flow-logs"
      Type = "VPC Flow Logs"
    }
  )
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  count                = var.enable_vpc_flow_logs ? 1 : 0
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log[0].arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  iam_role_arn         = var.vpc_flow_log_iam_role_arn

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc-flow-logs"
      Type = "VPC Flow Logs"
    }
  )
}

# =============================================================================
# CLOUDTRAIL
# =============================================================================

# CloudTrail Log Group
resource "aws_cloudwatch_log_group" "cloudtrail" {
  count             = var.enable_cloudtrail ? 1 : 0
  name              = local.cloudtrail_log_group_name
  retention_in_days = var.cloudtrail_retention_days

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudtrail-logs"
      Type = "CloudTrail"
    }
  )
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  count                      = var.enable_cloudtrail ? 1 : 0
  name                       = "${local.name_prefix}-cloudtrail"
  s3_bucket_name             = var.cloudtrail_s3_bucket_name != "" ? var.cloudtrail_s3_bucket_name : "aws-cloudtrail-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  is_multi_region_trail      = true
  enable_log_file_validation = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
  cloud_watch_logs_role_arn  = var.vpc_flow_log_iam_role_arn # Reuse the same role

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudtrail"
      Type = "CloudTrail"
    }
  )
}

# =============================================================================
# SNS NOTIFICATIONS
# =============================================================================

# SNS Topic for Notifications
resource "aws_sns_topic" "notifications" {
  count = var.create_sns_topic ? 1 : 0
  name  = local.sns_topic_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-notifications"
      Type = "Notifications"
    }
  )
}

# SNS Topic Subscription (Email)
resource "aws_sns_topic_subscription" "email" {
  count     = var.create_sns_topic && var.alarm_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.notifications[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# =============================================================================
# CLOUDWATCH ALARMS
# =============================================================================

# High CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${local.name_prefix}-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = var.create_sns_topic ? [aws_sns_topic.notifications[0].arn] : []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cpu-alarm"
      Type = "CPU Monitoring"
    }
  )
}

# High Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${local.name_prefix}-memory-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.memory_threshold
  alarm_description   = "This metric monitors EC2 memory utilization"
  alarm_actions       = var.create_sns_topic ? [aws_sns_topic.notifications[0].arn] : []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-memory-alarm"
      Type = "Memory Monitoring"
    }
  )
}

# =============================================================================
# CLOUDWATCH DASHBOARDS
# =============================================================================

# Overview Dashboard
resource "aws_cloudwatch_dashboard" "overview" {
  count          = var.enable_dashboards ? 1 : 0
  dashboard_name = "${local.name_prefix}-overview-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${local.name_prefix}-asg"],
            [".", "MemoryUtilization", ".", "."],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "EC2 Metrics Overview"
        }
      }
    ]
  })


}
