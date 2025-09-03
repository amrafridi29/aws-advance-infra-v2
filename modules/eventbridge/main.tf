# EventBridge Module - Main Configuration
# This file creates EventBridge rules for ECR scan events

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
      Purpose     = "Event Processing"
      ManagedBy   = "Terraform"
      Component   = "EventBridge"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# EVENTBRIDGE BUS
# =============================================================================

# Default EventBridge Bus
resource "aws_cloudwatch_event_bus" "default" {
  count = var.enable_default_bus ? 1 : 0

  name = "${local.name_prefix}-event-bus"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-event-bus"
      Type = "Event Bus"
    }
  )
}

# =============================================================================
# ECR SCAN EVENT RULES
# =============================================================================

# ECR Scan Finding Event Rule
resource "aws_cloudwatch_event_rule" "ecr_scan_finding" {
  count = var.enable_ecr_scan_events ? 1 : 0

  name        = "${local.name_prefix}-ecr-scan-finding"
  description = "Capture ECR image scan findings"

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Scan"]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecr-scan-finding"
      Type = "ECR Scan Rule"
    }
  )
}

# ECR Scan Complete Event Rule
resource "aws_cloudwatch_event_rule" "ecr_scan_complete" {
  count = var.enable_ecr_scan_events ? 1 : 0

  name        = "${local.name_prefix}-ecr-scan-complete"
  description = "Capture ECR image scan completion events"

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Scan"]
    detail = {
      scan-status = ["COMPLETE"]
    }
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecr-scan-complete"
      Type = "ECR Scan Complete Rule"
    }
  )
}

# =============================================================================
# EVENT TARGETS
# =============================================================================

# Target for ECR Scan Finding Events
resource "aws_cloudwatch_event_target" "ecr_scan_finding" {
  count = var.enable_ecr_scan_events && var.enable_sns_notifications ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ecr_scan_finding[0].name
  target_id = "ECRScanFindingTarget"
  arn       = var.sns_topic_arn

  input_transformer {
    input_paths = {
      repository = "$.detail.repository-name"
      image_tag  = "$.detail.image-tag"
      severity   = "$.detail.finding-severity-counts"
      scan_time  = "$.time"
    }
    input_template = <<EOF
{
  "Message": "ECR Image Scan Finding Detected\nRepository: <repository>\nImage Tag: <image_tag>\nSeverity Counts: <severity>\nScan Time: <scan_time>",
  "Subject": "ECR Security Alert - <repository>:<image_tag>"
}
EOF
  }
}

# Target for ECR Scan Complete Events
resource "aws_cloudwatch_event_target" "ecr_scan_complete" {
  count = var.enable_ecr_scan_events && var.enable_sns_notifications ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ecr_scan_complete[0].name
  target_id = "ECRScanCompleteTarget"
  arn       = var.sns_topic_arn

  input_transformer {
    input_paths = {
      repository = "$.detail.repository-name"
      image_tag  = "$.detail.image-tag"
      scan_time  = "$.time"
    }
    input_template = <<EOF
{
  "Message": "ECR Image Scan Completed\nRepository: <repository>\nImage Tag: <image_tag>\nScan Time: <scan_time>",
  "Subject": "ECR Scan Complete - <repository>:<image_tag>"
}
EOF
  }
}
