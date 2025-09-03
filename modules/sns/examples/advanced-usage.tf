# Advanced SNS Module Usage Example
# This example shows advanced configurations with multiple topics, different protocols, and advanced features

# Advanced SNS Module Configuration
module "sns_advanced" {
  source = "../../sns"

  # Required variables
  environment  = "production"
  project_name = "myapp"

  # Enable ECR notifications with advanced configuration
  enable_ecr_notifications = true

  # Multiple email addresses for different notification types
  email_subscriptions = [
    "devops@mycompany.com",
    "team@mycompany.com",
    "monitoring@mycompany.com"
  ]

  # Security team email addresses
  security_email_subscriptions = [
    "security@mycompany.com",
    "admin@mycompany.com",
    "compliance@mycompany.com"
  ]

  # Advanced tagging strategy
  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
    CostCenter  = "IT-Infrastructure"
    ManagedBy   = "Terraform"
    Purpose     = "Notifications"
    Component   = "SNS"
  }
}

# Custom SNS Topics for additional use cases
resource "aws_sns_topic" "application_alerts" {
  name = "myapp-application-alerts"

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Application Alerts"
    Component   = "SNS"
  }
}

resource "aws_sns_topic" "infrastructure_alerts" {
  name = "myapp-infrastructure-alerts"

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Infrastructure Alerts"
    Component   = "SNS"
  }
}

resource "aws_sns_topic" "compliance_notifications" {
  name = "myapp-compliance-notifications"

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Compliance Notifications"
    Component   = "SNS"
  }
}

# SNS Topic Subscriptions with different protocols
resource "aws_sns_topic_subscription" "application_alerts_email" {
  for_each = toset([
    "devops@mycompany.com",
    "team@mycompany.com"
  ])

  topic_arn = aws_sns_topic.application_alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_sns_topic_subscription" "infrastructure_alerts_sms" {
  topic_arn = aws_sns_topic.infrastructure_alerts.arn
  protocol  = "sms"
  endpoint  = "+1234567890"
}

resource "aws_sns_topic_subscription" "compliance_notifications_email" {
  for_each = toset([
    "compliance@mycompany.com",
    "legal@mycompany.com"
  ])

  topic_arn = aws_sns_topic.compliance_notifications.arn
  protocol  = "email"
  endpoint  = each.value
}

# SNS Topic Policies for security
resource "aws_sns_topic_policy" "application_alerts" {
  arn = aws_sns_topic.application_alerts.arn

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
        Resource = aws_sns_topic.application_alerts.arn
      },
      {
        Sid    = "AllowCloudWatchPublish"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.application_alerts.arn
      }
    ]
  })
}

resource "aws_sns_topic_policy" "infrastructure_alerts" {
  arn = aws_sns_topic.infrastructure_alerts.arn

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
        Resource = aws_sns_topic.infrastructure_alerts.arn
      },
      {
        Sid    = "AllowCloudWatchPublish"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.infrastructure_alerts.arn
      }
    ]
  })
}

resource "aws_sns_topic_policy" "compliance_notifications" {
  arn = aws_sns_topic.compliance_notifications.arn

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
        Resource = aws_sns_topic.compliance_notifications.arn
      },
      {
        Sid    = "AllowCloudWatchPublish"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.compliance_notifications.arn
      }
    ]
  })
}

# SNS Topic with KMS encryption
resource "aws_sns_topic" "encrypted_notifications" {
  name = "myapp-encrypted-notifications"

  kms_master_key_id = "alias/aws/sns"

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Encrypted Notifications"
    Component   = "SNS"
  }
}

resource "aws_sns_topic_subscription" "encrypted_notifications_email" {
  topic_arn = aws_sns_topic.encrypted_notifications.arn
  protocol  = "email"
  endpoint  = "security@mycompany.com"
}

# SNS Topic with delivery status logging
resource "aws_sns_topic" "monitoring_notifications" {
  name = "myapp-monitoring-notifications"

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Monitoring Notifications"
    Component   = "SNS"
  }
}

resource "aws_sns_topic_subscription" "monitoring_notifications_email" {
  topic_arn = aws_sns_topic.monitoring_notifications.arn
  protocol  = "email"
  endpoint  = "monitoring@mycompany.com"
}

# CloudWatch Log Group for SNS delivery status
resource "aws_cloudwatch_log_group" "sns_delivery_status" {
  name              = "/aws/sns/myapp-delivery-status"
  retention_in_days = 30

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "SNS Delivery Logging"
  }
}

# Outputs for advanced configuration
output "sns_advanced_outputs" {
  description = "Advanced SNS module outputs"
  value = {
    # Basic module outputs
    ecr_notifications_topic_name      = module.sns_advanced.ecr_notifications_topic_name
    ecr_notifications_topic_arn       = module.sns_advanced.ecr_notifications_topic_arn
    ecr_security_alerts_topic_name    = module.sns_advanced.ecr_security_alerts_topic_name
    ecr_security_alerts_topic_arn     = module.sns_advanced.ecr_security_alerts_topic_arn
    ecr_notifications_subscriptions   = module.sns_advanced.ecr_notifications_subscriptions
    ecr_security_alerts_subscriptions = module.sns_advanced.ecr_security_alerts_subscriptions
    sns_summary                       = module.sns_advanced.sns_summary

    # Custom topic outputs
    application_alerts_topic_name = aws_sns_topic.application_alerts.name
    application_alerts_topic_arn  = aws_sns_topic.application_alerts.arn

    infrastructure_alerts_topic_name = aws_sns_topic.infrastructure_alerts.name
    infrastructure_alerts_topic_arn  = aws_sns_topic.infrastructure_alerts.arn

    compliance_notifications_topic_name = aws_sns_topic.compliance_notifications.name
    compliance_notifications_topic_arn  = aws_sns_topic.compliance_notifications.arn

    encrypted_notifications_topic_name = aws_sns_topic.encrypted_notifications.name
    encrypted_notifications_topic_arn  = aws_sns_topic.encrypted_notifications.arn

    monitoring_notifications_topic_name = aws_sns_topic.monitoring_notifications.name
    monitoring_notifications_topic_arn  = aws_sns_topic.monitoring_notifications.arn

    # Log group
    sns_delivery_status_log_group_name = aws_cloudwatch_log_group.sns_delivery_status.name
    sns_delivery_status_log_group_arn  = aws_cloudwatch_log_group.sns_delivery_status.arn
  }
}

# Data sources for existing SNS topics (if not created by this module)
data "aws_sns_topic" "existing_topic" {
  name = "my-existing-topic"
}

# IAM role for SNS publishing permissions
resource "aws_iam_role" "sns_publisher" {
  name = "myapp-sns-publisher-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "SNS Publishing"
  }
}

resource "aws_iam_role_policy" "sns_publisher" {
  name = "myapp-sns-publisher-policy"
  role = aws_iam_role.sns_publisher.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          module.sns_advanced.ecr_notifications_topic_arn,
          module.sns_advanced.ecr_security_alerts_topic_arn,
          aws_sns_topic.application_alerts.arn,
          aws_sns_topic.infrastructure_alerts.arn,
          aws_sns_topic.compliance_notifications.arn
        ]
      }
    ]
  })
}
