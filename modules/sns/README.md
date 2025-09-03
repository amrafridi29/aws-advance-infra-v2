# SNS Module

This module creates and manages AWS SNS topics and subscriptions for ECR scan notifications via email.

## Purpose

- **Email Notifications**: Send ECR scan results and security alerts via email
- **Topic Management**: Create separate topics for general notifications and security alerts
- **Subscription Management**: Manage email subscriptions for different notification types
- **Integration**: Connect with EventBridge for automated notifications

## Architecture

```
SNS Topics
├── ECR Notifications Topic
│   ├── General scan completion notifications
│   └── Email subscriptions
└── ECR Security Alerts Topic
    ├── Security vulnerability alerts
    └── Security team email subscriptions
```

## Resources Created

- **SNS Topics**: Separate topics for notifications and security alerts
- **Email Subscriptions**: Direct email delivery for notifications
- **Topic Policies**: Allow EventBridge and CloudWatch to publish
- **Subscription Management**: Automatic email subscription handling

## Usage

```terraform
module "sns" {
  source = "../../modules/sns"

  environment  = "production"
  project_name = "my-app"

  # Enable both notification types
  enable_ecr_notifications = true
  enable_ecr_security_alerts = true

  # Email subscriptions
  email_subscriptions = [
    "devops@company.com",
    "team@company.com"
  ]

  security_email_subscriptions = [
    "security@company.com",
    "admin@company.com"
  ]

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

## Notification Types

### ECR Notifications

- **Purpose**: General scan completion notifications
- **Recipients**: Development and DevOps teams
- **Content**: Scan status, repository info, timestamps

### ECR Security Alerts

- **Purpose**: Security vulnerability notifications
- **Recipients**: Security team and administrators
- **Content**: Vulnerability details, severity levels, remediation steps

## Email Subscription Process

1. **Initial Subscription**: Terraform creates SNS subscriptions
2. **Confirmation Email**: AWS sends confirmation email to each address
3. **Subscription Confirmation**: Recipients must click confirmation link
4. **Active Notifications**: Emails start receiving notifications

## Outputs

- `ecr_notifications_topic_arn`: ARN of the notifications topic
- `ecr_security_alerts_topic_arn`: ARN of the security alerts topic
- `ecr_notifications_subscriptions`: List of notification email addresses
- `ecr_security_alerts_subscriptions`: List of security alert email addresses
- `sns_summary`: Summary of SNS infrastructure

## Integration

### With EventBridge Module

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

## Best Practices

1. **Separate Topics**: Use different topics for different notification types
2. **Email Confirmation**: Ensure recipients confirm SNS subscriptions
3. **Security Team**: Route security alerts to dedicated security team
4. **Testing**: Test notification delivery in staging environment first

## Dependencies

- AWS Provider
- EventBridge module for event routing
- Email addresses for subscriptions
