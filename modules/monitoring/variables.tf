# Monitoring Module - Variables
# This file defines all variables used in the monitoring module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for VPC Flow Logs"
  type        = string
}

# VPC Flow Logs Configuration
variable "enable_vpc_flow_logs" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 30
}

variable "vpc_flow_log_iam_role_arn" {
  description = "ARN of the IAM role for VPC Flow Logs (from security module)"
  type        = string
}

# CloudWatch Logs Configuration
variable "enable_cloudwatch_logs" {
  description = "Whether to enable CloudWatch logging"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "create_application_log_group" {
  description = "Whether to create application log group"
  type        = bool
  default     = true
}

variable "create_system_log_group" {
  description = "Whether to create system log group"
  type        = bool
  default     = true
}

variable "create_security_log_group" {
  description = "Whether to create security log group"
  type        = bool
  default     = true
}

# CloudTrail Configuration
variable "enable_cloudtrail" {
  description = "Whether to enable CloudTrail"
  type        = bool
  default     = false
}

variable "cloudtrail_retention_days" {
  description = "Number of days to retain CloudTrail logs"
  type        = number
  default     = 90
}

variable "cloudtrail_log_group_name" {
  description = "Name for the CloudTrail log group"
  type        = string
  default     = ""
}

variable "cloudtrail_s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs (must exist)"
  type        = string
  default     = ""
}

# CloudWatch Alarms Configuration
variable "enable_alarms" {
  description = "Whether to create CloudWatch alarms"
  type        = bool
  default     = false
}

variable "alarm_email" {
  description = "Email address for alarm notifications"
  type        = string
  default     = ""
}

variable "cpu_threshold" {
  description = "CPU utilization threshold for alarms (%)"
  type        = number
  default     = 80
}

variable "memory_threshold" {
  description = "Memory utilization threshold for alarms (%)"
  type        = number
  default     = 80
}

variable "disk_threshold" {
  description = "Disk utilization threshold for alarms (%)"
  type        = number
  default     = 80
}

# CloudWatch Dashboards Configuration
variable "enable_dashboards" {
  description = "Whether to create CloudWatch dashboards"
  type        = bool
  default     = false
}

# ECS Log Groups Configuration
variable "enable_ecs_log_groups" {
  description = "Whether to create ECS log groups"
  type        = bool
  default     = false
}

variable "ecs_log_groups" {
  description = "List of ECS log group configurations"
  type = list(object({
    name              = string
    retention_in_days = number
    kms_key_arn       = string
  }))
  default = []
}

variable "dashboard_names" {
  description = "List of dashboard names to create"
  type        = list(string)
  default     = ["overview", "networking", "security"]
}

# SNS Configuration
variable "create_sns_topic" {
  description = "Whether to create SNS topic for notifications"
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "Name for the SNS topic"
  type        = string
  default     = ""
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
