# ElastiCache Module Variables

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_elasticache" {
  description = "Whether to enable ElastiCache Redis cluster"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID where ElastiCache will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ElastiCache subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access Redis"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access Redis"
  type        = list(string)
  default     = []
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "redis_parameters" {
  description = "Redis parameter group parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "maxmemory-policy"
      value = "allkeys-lru"
    },
    {
      name  = "notify-keyspace-events"
      value = "Ex"
    }
  ]
}

variable "multi_az_enabled" {
  description = "Whether to enable Multi-AZ for high availability"
  type        = bool
  default     = false
}

variable "snapshot_retention_days" {
  description = "Number of days to retain Redis snapshots"
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "Time window for Redis snapshots (HH:MM-HH:MM UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Time window for Redis maintenance (ddd:HH:MM-ddd:HH:MM UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "enable_logging" {
  description = "Whether to enable CloudWatch logging for Redis"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain Redis logs"
  type        = number
  default     = 30
}

variable "enable_monitoring" {
  description = "Whether to enable CloudWatch monitoring for Redis"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "List of ARNs for CloudWatch alarm actions (SNS topics, etc.)"
  type        = list(string)
  default     = []
}
