# Compute Module - Variables
# This file defines all variables used in the compute module

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
  description = "ID of the VPC for ECS cluster"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for load balancer"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS services"
  type        = list(string)
}

# ECS Configuration
variable "enable_ecs" {
  description = "Whether to create ECS infrastructure"
  type        = bool
  default     = true
}

variable "ecs_cluster_name" {
  description = "Name for the ECS cluster"
  type        = string
  default     = ""
}

variable "ecs_capacity_providers" {
  description = "List of ECS capacity providers"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "ecs_cluster_settings" {
  description = "ECS cluster settings"
  type = object({
    container_insights = bool
  })
  default = {
    container_insights = true
  }
}



# ECS Service Configuration
variable "enable_ecs_service" {
  description = "Whether to create ECS service"
  type        = bool
  default     = true
}

variable "ecs_service_name" {
  description = "Name for the ECS service"
  type        = string
  default     = ""
}

variable "ecs_task_definition_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = ""
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory for the ECS task in MiB"
  type        = number
  default     = 512
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
  default     = ""
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
  default     = ""
}



variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_service_security_group_id" {
  description = "ID of the ECS service security group"
  type        = string
  default     = ""
}

variable "health_check_grace_period_seconds" {
  description = "Grace period for health checks in seconds"
  type        = number
  default     = 60
}

# Load Balancer Integration (Optional)
variable "enable_load_balancer_integration" {
  description = "Whether to integrate with load balancer from networking module"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "ARN of the target group from networking module"
  type        = string
  default     = ""
}

# Advanced Container Configuration
variable "containers" {
  description = "List of containers to run in the ECS task"
  type = list(object({
    name      = string
    image     = string
    port      = number
    protocol  = string
    essential = bool
    cpu       = optional(number)
    memory    = optional(number)
    environment = optional(list(object({
      name  = string
      value = string
    })), [])
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })), [])
    health_check = optional(object({
      command     = list(string)
      interval    = number
      timeout     = number
      retries     = number
      startPeriod = number
    }))
    log_configuration = optional(object({
      log_driver = string
      options    = map(string)
    }))
  }))
  default = []
  validation {
    condition     = length(var.containers) > 0
    error_message = "At least one container must be specified in the containers list."
  }
}

variable "volumes" {
  description = "List of volumes to attach to the ECS task"
  type = list(object({
    name = string
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = string
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
    }))
    docker_volume_configuration = optional(object({
      scope       = string
      driver      = string
      driver_opts = optional(map(string))
      labels      = optional(map(string))
    }))
  }))
  default = []
}

variable "mount_points" {
  description = "List of mount points for volumes"
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = bool
  }))
  default = []
}



variable "enable_execute_command" {
  description = "Whether to enable ECS Exec for debugging"
  type        = bool
  default     = false
}



variable "scheduled_scaling" {
  description = "Scheduled auto scaling rules"
  type = list(object({
    schedule     = string
    min_capacity = number
    max_capacity = number
  }))
  default = []
}

# Service Discovery Configuration
variable "enable_service_discovery" {
  description = "Whether to enable service discovery"
  type        = bool
  default     = false
}

variable "service_discovery_namespace" {
  description = "Name for the service discovery namespace"
  type        = string
  default     = ""
}

variable "service_discovery_service_name" {
  description = "Name for the service discovery service"
  type        = string
  default     = ""
}

# Auto Scaling Configuration
variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaling"
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Minimum number of tasks for auto-scaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks for auto-scaling"
  type        = number
  default     = 3
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization percentage for auto-scaling"
  type        = number
  default     = 70
}

variable "target_memory_utilization" {
  description = "Target memory utilization percentage for auto-scaling"
  type        = number
  default     = 70
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
