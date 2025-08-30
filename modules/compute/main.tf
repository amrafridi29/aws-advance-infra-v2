# Compute Module - Main Configuration
# This file creates comprehensive ECS compute infrastructure

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Generate names if not provided
  ecs_cluster_name               = var.ecs_cluster_name != "" ? var.ecs_cluster_name : "${var.project_name}-${var.environment}-cluster"
  ecs_service_name               = var.ecs_service_name != "" ? var.ecs_service_name : "${var.project_name}-${var.environment}-service"
  ecs_task_definition_family     = var.ecs_task_definition_family != "" ? var.ecs_task_definition_family : "${var.project_name}-${var.environment}-task"
  service_discovery_namespace    = var.service_discovery_namespace != "" ? var.service_discovery_namespace : "${var.project_name}.${var.environment}.local"
  service_discovery_service_name = var.service_discovery_service_name != "" ? var.service_discovery_service_name : "${var.project_name}-${var.environment}-service"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "Compute Infrastructure"
      ManagedBy   = "Terraform"
      Component   = "Compute"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# ECS CLUSTER
# =============================================================================

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  count = var.enable_ecs ? 1 : 0

  name = local.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_settings.container_insights ? "enabled" : "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.ecs_cluster_name
      Type = "ECS Cluster"
    }
  )
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "main" {
  count = var.enable_ecs ? 1 : 0

  cluster_name = aws_ecs_cluster.main[0].name

  capacity_providers = var.ecs_capacity_providers

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }
}



# =============================================================================
# SERVICE DISCOVERY
# =============================================================================

# Service Discovery Private DNS Namespace
resource "aws_service_discovery_private_dns_namespace" "main" {
  count = var.enable_service_discovery ? 1 : 0

  name        = local.service_discovery_namespace
  description = "Service discovery namespace for ${local.name_prefix}"
  vpc         = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.service_discovery_namespace
      Type = "Service Discovery Namespace"
    }
  )
}

# Service Discovery Service
resource "aws_service_discovery_service" "main" {
  count = var.enable_service_discovery ? 1 : 0

  name = local.service_discovery_service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main[0].id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.service_discovery_service_name
      Type = "Service Discovery Service"
    }
  )
}

# =============================================================================
# ECS TASK DEFINITION
# =============================================================================

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  count = var.enable_ecs && var.enable_ecs_service ? 1 : 0

  family                   = local.ecs_task_definition_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn != "" ? var.ecs_task_execution_role_arn : null
  task_role_arn            = var.ecs_task_role_arn != "" ? var.ecs_task_role_arn : null



  # Volumes
  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name
      dynamic "efs_volume_configuration" {
        for_each = volume.value.efs_volume_configuration != null ? [volume.value.efs_volume_configuration] : []
        content {
          file_system_id          = efs_volume_configuration.value.file_system_id
          root_directory          = efs_volume_configuration.value.root_directory
          transit_encryption      = efs_volume_configuration.value.transit_encryption
          transit_encryption_port = efs_volume_configuration.value.transit_encryption_port
        }
      }
      dynamic "docker_volume_configuration" {
        for_each = volume.value.docker_volume_configuration != null ? [volume.value.docker_volume_configuration] : []
        content {
          scope       = docker_volume_configuration.value.scope
          driver      = docker_volume_configuration.value.driver
          driver_opts = docker_volume_configuration.value.driver_opts
          labels      = docker_volume_configuration.value.labels
        }
      }
    }
  }

  container_definitions = jsonencode([
    for container in var.containers : {
      name  = container.name
      image = container.image
      portMappings = [
        {
          containerPort = container.port
          protocol      = container.protocol
        }
      ]
      environment = container.environment
      secrets     = container.secrets

      # Health Check (only if configured)
      healthCheck = container.health_check != null ? {
        command     = container.health_check.command
        interval    = container.health_check.interval
        timeout     = container.health_check.timeout
        retries     = container.health_check.retries
        startPeriod = container.health_check.startPeriod
      } : null

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${local.ecs_task_definition_family}"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      essential = container.essential
      cpu       = container.cpu
      memory    = container.memory
      mountPoints = [
        for mount in var.mount_points : {
          sourceVolume  = mount.sourceVolume
          containerPath = mount.containerPath
          readOnly      = mount.readOnly
        }
      ]
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = local.ecs_task_definition_family
      Type = "ECS Task Definition"
    }
  )
}

# =============================================================================
# ECS SERVICE
# =============================================================================

# ECS Service
resource "aws_ecs_service" "main" {
  count = var.enable_ecs && var.enable_ecs_service ? 1 : 0

  name            = local.ecs_service_name
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.main[0].arn
  desired_count   = var.ecs_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = var.ecs_service_security_group_id != "" ? [var.ecs_service_security_group_id] : []
    assign_public_ip = false
  }

  # Health Check Configuration
  health_check_grace_period_seconds = 60

  # Load Balancer Integration
  dynamic "load_balancer" {
    for_each = var.enable_load_balancer_integration && var.target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.containers[0].name
      container_port   = var.containers[0].port
    }
  }

  # ECS Exec Configuration
  enable_execute_command = var.enable_execute_command

  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []
    content {
      registry_arn = aws_service_discovery_service.main[0].arn
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.ecs_service_name
      Type = "ECS Service"
    }
  )
}

# =============================================================================
# AUTO SCALING
# =============================================================================

# ECS Service Auto Scaling
resource "aws_appautoscaling_target" "ecs_target" {
  count = var.enable_auto_scaling && var.enable_ecs_service ? 1 : 0

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main[0].name}/${aws_ecs_service.main[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU-based Auto Scaling Policy
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  count = var.enable_auto_scaling && var.enable_ecs_service ? 1 : 0

  name               = "${local.name_prefix}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.target_cpu_utilization
  }
}

# Memory-based Auto Scaling Policy
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  count = var.enable_auto_scaling && var.enable_ecs_service ? 1 : 0

  name               = "${local.name_prefix}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = var.target_memory_utilization
  }
}



# Scheduled Auto Scaling
resource "aws_appautoscaling_scheduled_action" "ecs_scheduled_scaling" {
  for_each = var.enable_auto_scaling && var.enable_ecs_service ? { for idx, schedule in var.scheduled_scaling : schedule.schedule => schedule } : {}

  name               = "${local.name_prefix}-scheduled-scaling-${each.key}"
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension

  scalable_target_action {
    min_capacity = each.value.min_capacity
    max_capacity = each.value.max_capacity
  }

  schedule = each.value.schedule
}


