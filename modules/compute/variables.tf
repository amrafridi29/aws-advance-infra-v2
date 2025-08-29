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
    default_capacity_provider_strategy = list(object({
      capacity_provider = string
      weight            = number
      base              = number
    }))
  })
  default = {
    container_insights = true
    default_capacity_provider_strategy = [
      {
        capacity_provider = "FARGATE"
        weight            = 1
        base              = 0
      }
    ]
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

variable "ecs_container_name" {
  description = "Name for the ECS container"
  type        = string
  default     = ""
}

variable "ecs_container_image" {
  description = "Docker image for the ECS container"
  type        = string
  default     = "nginx:alpine"
}

variable "ecs_container_port" {
  description = "Port exposed by the ECS container"
  type        = number
  default     = 80
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
