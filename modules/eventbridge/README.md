# EventBridge Module

This module creates and manages AWS EventBridge rules for ECR image scan events and notifications.

## Purpose

- **ECR Scan Monitoring**: Capture ECR image scan findings and completion events
- **Event Processing**: Route events to appropriate targets (SNS, Lambda, etc.)
- **Security Notifications**: Enable real-time alerts for security vulnerabilities
- **Integration**: Connect ECR scanning with notification systems

## Architecture

```
ECR Image Scan Events
├── Scan Finding Events (CRITICAL, HIGH, MEDIUM, LOW)
│   ├── EventBridge Rule
│   └── SNS Notification
└── Scan Complete Events
    ├── EventBridge Rule
    └── SNS Notification
```

## Resources Created

- **EventBridge Rules**: Capture ECR scan events
- **Event Targets**: Route events to SNS topics
- **Event Patterns**: Filter specific ECR scan events
- **Input Transformers**: Format event data for notifications

## Usage

```terraform
module "eventbridge" {
  source = "../../modules/eventbridge"

  environment  = "production"
  project_name = "my-app"

  # Enable ECR scan events
  enable_ecr_scan_events = true
  enable_sns_notifications = true
  sns_topic_arn = module.sns.ecr_notifications_topic_arn

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

## Event Types

### ECR Scan Finding Events

- **Triggered**: When vulnerabilities are found in scanned images
- **Severity Levels**: CRITICAL, HIGH, MEDIUM, LOW
- **Notification**: Email alert with vulnerability details

### ECR Scan Complete Events

- **Triggered**: When image scanning completes (successful or failed)
- **Information**: Repository name, image tag, scan timestamp
- **Notification**: Status update email

## Outputs

- `ecr_scan_finding_rule_arn`: ARN of the scan finding event rule
- `ecr_scan_complete_rule_arn`: ARN of the scan complete event rule
- `eventbridge_summary`: Summary of EventBridge infrastructure

## Integration

### With SNS Module

```terraform
module "sns" {
  source = "../../modules/sns"
  # ... SNS configuration
}

module "eventbridge" {
  source = "../../modules/eventbridge"
  # ... EventBridge configuration
  sns_topic_arn = module.sns.ecr_notifications_topic_arn
}
```

### With ECR Module

The EventBridge module automatically captures events from ECR repositories when image scanning is enabled.

## Best Practices

1. **Enable SNS Notifications**: Route events to email/Slack for immediate alerts
2. **Filter by Severity**: Focus on CRITICAL and HIGH severity findings
3. **Monitor Event Rules**: Use CloudWatch to track event processing
4. **Test Notifications**: Verify email delivery and formatting

## Dependencies

- AWS Provider
- SNS topic for notifications
- ECR repositories with image scanning enabled
