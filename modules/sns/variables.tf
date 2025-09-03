# SNS Module - Variables
# This file defines all variables used in the SNS module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# SNS Topic Configuration
variable "enable_ecr_notifications" {
  description = "Whether to create SNS topic for ECR notifications"
  type        = bool
  default     = true
}

variable "enable_ecr_security_alerts" {
  description = "Whether to create SNS topic for ECR security alerts"
  type        = bool
  default     = true
}

# Email Subscriptions
variable "email_subscriptions" {
  description = "List of email addresses for ECR notifications"
  type        = list(string)
  default     = []
}

variable "security_email_subscriptions" {
  description = "List of email addresses for ECR security alerts"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
