# Advanced EventBridge Module Usage Example
# This example shows advanced configurations with custom event buses, multiple targets, and complex event patterns

# Custom Event Bus for advanced event routing
resource "aws_cloudwatch_event_bus" "custom" {
  name = "myapp-custom-event-bus"
  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Custom Event Routing"
  }
}

# Advanced EventBridge Module Configuration
module "eventbridge_advanced" {
  source = "../../eventbridge"

  # Required variables
  environment  = "production"
  project_name = "myapp"

  # Enable custom event bus
  enable_default_bus = true

  # Enable ECR scan events with custom configuration
  enable_ecr_scan_events   = true
  enable_sns_notifications = true

  # Multiple SNS topics for different notification types
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:my-advanced-notifications-topic"

  # Advanced tagging strategy
  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
    CostCenter  = "IT-Infrastructure"
    ManagedBy   = "Terraform"
    Purpose     = "Event Processing"
    Component   = "EventBridge"
  }
}

# Custom EventBridge Rules for additional event types
resource "aws_cloudwatch_event_rule" "ecs_deployment" {
  name        = "myapp-ecs-deployment-events"
  description = "Capture ECS deployment events"

  event_pattern = jsonencode({
    source      = ["aws.ecs"]
    detail-type = ["ECS Deployment State Change"]
    detail = {
      state = ["IN_PROGRESS", "COMPLETED", "FAILED"]
    }
  })

  event_bus_name = aws_cloudwatch_event_bus.custom.name

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "ECS Monitoring"
  }
}

resource "aws_cloudwatch_event_rule" "lambda_errors" {
  name        = "myapp-lambda-error-events"
  description = "Capture Lambda function errors"

  event_pattern = jsonencode({
    source      = ["aws.lambda"]
    detail-type = ["Lambda Function Error"]
    detail = {
      errorCode = ["*"]
    }
  })

  event_bus_name = aws_cloudwatch_event_bus.custom.name

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Lambda Monitoring"
  }
}

# Event targets for custom rules
resource "aws_cloudwatch_event_target" "ecs_deployment_sns" {
  rule           = aws_cloudwatch_event_rule.ecs_deployment.name
  target_id      = "ECSDeploymentSNSTarget"
  arn            = "arn:aws:sns:us-east-1:123456789012:my-ecs-notifications-topic"
  event_bus_name = aws_cloudwatch_event_bus.custom.name

  input_transformer {
    input_paths = {
      service    = "$.detail.service"
      deployment = "$.detail.deploymentId"
      state      = "$.detail.state"
      timestamp  = "$.time"
    }
    input_template = jsonencode({
      Message = "ECS Deployment ${state}\nService: ${service}\nDeployment ID: ${deployment}\nTime: ${timestamp}"
      Subject = "ECS Deployment Alert - ${service}: ${state}"
    })
  }
}

resource "aws_cloudwatch_event_target" "lambda_errors_sns" {
  rule           = aws_cloudwatch_event_rule.lambda_errors.name
  target_id      = "LambdaErrorsSNSTarget"
  arn            = "arn:aws:sns:us-east-1:123456789012:my-lambda-notifications-topic"
  event_bus_name = aws_cloudwatch_event_bus.custom.name

  input_transformer {
    input_paths = {
      function_name = "$.detail.functionName"
      error_code    = "$.detail.errorCode"
      error_message = "$.detail.errorMessage"
      timestamp     = "$.time"
    }
    input_template = jsonencode({
      Message = "Lambda Function Error\nFunction: ${function_name}\nError Code: ${error_code}\nError Message: ${error_message}\nTime: ${timestamp}"
      Subject = "Lambda Error Alert - ${function_name}"
    })
  }
}

# EventBridge Archive for compliance and debugging
resource "aws_cloudwatch_event_archive" "main" {
  name             = "myapp-event-archive"
  event_source_arn = aws_cloudwatch_event_bus.custom.arn
  retention_days   = 30

  #   tags = {
  #     Environment = "production"
  #     Project     = "myapp"
  #     Purpose     = "Event Archiving"
  #   }
}

# Outputs for advanced configuration
output "eventbridge_advanced_outputs" {
  description = "Advanced EventBridge module outputs"
  value = {
    # Basic module outputs
    event_bus_name              = module.eventbridge_advanced.event_bus_name
    event_bus_arn               = module.eventbridge_advanced.event_bus_arn
    ecr_scan_complete_rule_name = module.eventbridge_advanced.ecr_scan_complete_rule_name
    ecr_scan_finding_rule_name  = module.eventbridge_advanced.ecr_scan_finding_rule_name
    ecr_scan_complete_rule_arn  = module.eventbridge_advanced.ecr_scan_complete_rule_arn
    ecr_scan_finding_rule_arn   = module.eventbridge_advanced.ecr_scan_finding_rule_arn
    eventbridge_summary         = module.eventbridge_advanced.eventbridge_summary

    # Custom event bus outputs
    custom_event_bus_name = aws_cloudwatch_event_bus.custom.name
    custom_event_bus_arn  = aws_cloudwatch_event_bus.custom.arn

    # Custom rules
    ecs_deployment_rule_name = aws_cloudwatch_event_rule.ecs_deployment.name
    ecs_deployment_rule_arn  = aws_cloudwatch_event_rule.ecs_deployment.arn
    lambda_errors_rule_name  = aws_cloudwatch_event_rule.lambda_errors.name
    lambda_errors_rule_arn   = aws_cloudwatch_event_rule.lambda_errors.arn

    # Archive
    event_archive_name = aws_cloudwatch_event_archive.main.name
    event_archive_arn  = aws_cloudwatch_event_archive.main.arn
  }
}

# Data source for existing SNS topics (if not created by this module)
data "aws_sns_topic" "ecs_notifications" {
  name = "my-ecs-notifications-topic"
}

data "aws_sns_topic" "lambda_notifications" {
  name = "my-lambda-notifications-topic"
}
