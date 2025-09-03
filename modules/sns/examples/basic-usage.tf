# Basic SNS Module Usage Example
# This example shows the minimal configuration needed for ECR notifications

module "sns_basic" {
  source = "../../sns"

  # Required variables
  environment  = "production"
  project_name = "myapp"

  # Enable ECR notifications (default: true)
  enable_ecr_notifications = true

  # List of email addresses for ECR notifications
  email_subscriptions = [
    "devops@mycompany.com",
    "team@mycompany.com"
  ]

  # List of email addresses for ECR security alerts
  security_email_subscriptions = [
    "security@mycompany.com",
    "admin@mycompany.com"
  ]

  # Optional: Common tags
  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
  }
}

# Output the created resources
output "sns_basic_outputs" {
  description = "Basic SNS module outputs"
  value = {
    ecr_notifications_topic_name      = module.sns_basic.ecr_notifications_topic_name
    ecr_notifications_topic_arn       = module.sns_basic.ecr_notifications_topic_arn
    ecr_security_alerts_topic_name    = module.sns_basic.ecr_security_alerts_topic_name
    ecr_security_alerts_topic_arn     = module.sns_basic.ecr_security_alerts_topic_arn
    ecr_notifications_subscriptions   = module.sns_basic.ecr_notifications_subscriptions
    ecr_security_alerts_subscriptions = module.sns_basic.ecr_security_alerts_subscriptions
    sns_summary                       = module.sns_basic.sns_summary
  }
}
