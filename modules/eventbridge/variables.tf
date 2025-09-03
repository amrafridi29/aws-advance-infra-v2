# EventBridge Module - Variables
# This file defines all variables used in the EventBridge module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# EventBridge Configuration
variable "enable_default_bus" {
  description = "Whether to create the default EventBridge bus"
  type        = bool
  default     = false
}

variable "enable_ecr_scan_events" {
  description = "Whether to enable ECR scan event rules"
  type        = bool
  default     = true
}

variable "enable_sns_notifications" {
  description = "Whether to enable SNS notifications for events"
  type        = bool
  default     = true
}

# SNS Configuration
variable "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
  default     = ""
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
