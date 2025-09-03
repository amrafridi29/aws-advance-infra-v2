# Basic EventBridge Module Usage Example
# This example shows the minimal configuration needed to enable ECR scan notifications

module "eventbridge_basic" {
  source = "../../eventbridge"

  # Required variables
  environment  = "production"
  project_name = "myapp"

  # Enable ECR scan events (default: true)
  enable_ecr_scan_events = true

  # Enable SNS notifications (default: true)
  enable_sns_notifications = true

  # SNS topic ARN for notifications
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:my-notifications-topic"

  # Optional: Common tags
  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
  }
}

# Output the created resources
output "eventbridge_basic_outputs" {
  description = "Basic EventBridge module outputs"
  value = {
    event_bus_name              = module.eventbridge_basic.event_bus_name
    event_bus_arn               = module.eventbridge_basic.event_bus_arn
    ecr_scan_complete_rule_name = module.eventbridge_basic.ecr_scan_complete_rule_name
    ecr_scan_finding_rule_name  = module.eventbridge_basic.ecr_scan_finding_rule_name
    ecr_scan_complete_rule_arn  = module.eventbridge_basic.ecr_scan_complete_rule_arn
    ecr_scan_finding_rule_arn   = module.eventbridge_basic.ecr_scan_finding_rule_arn
    eventbridge_summary         = module.eventbridge_basic.eventbridge_summary
  }
}
