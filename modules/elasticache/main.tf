# ElastiCache Module - Redis Cluster
# Provides managed Redis caching for improved application performance

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(
    var.tags,
    {
      Component   = "ElastiCache"
      CostCenter  = "IT-Infrastructure"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "DevOps"
      Project     = var.project_name
      Purpose     = "Caching"
      Type        = "Redis Cluster"
    }
  )
}

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  count = var.enable_elasticache ? 1 : 0

  name       = "${local.name_prefix}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis-subnet-group"
      Type = "Subnet Group"
    }
  )
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  count = var.enable_elasticache ? 1 : 0

  family = "redis7"
  name   = "${local.name_prefix}-redis-params"

  dynamic "parameter" {
    for_each = var.redis_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis-params"
      Type = "Parameter Group"
    }
  )
}

# ElastiCache Security Group
resource "aws_security_group" "redis" {
  count = var.enable_elasticache ? 1 : 0

  name_prefix = "${local.name_prefix}-redis-sg"
  description = "Security group for Redis ElastiCache cluster"
  vpc_id      = var.vpc_id

  # Allow Redis port from application security group
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
    description     = "Redis access from application"
  }

  # Allow Redis port from specified CIDR blocks
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Redis access from CIDR"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis-sg"
      Type = "Security Group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ElastiCache Replication Group (Redis Cluster)
resource "aws_elasticache_replication_group" "main" {
  count = var.enable_elasticache ? 1 : 0

  replication_group_id = "${local.name_prefix}-redis"
  description          = "Redis cluster for ${var.project_name} ${var.environment}"
  node_type            = var.node_type
  port                 = 6379
  parameter_group_name = aws_elasticache_parameter_group.main[0].name
  subnet_group_name    = aws_elasticache_subnet_group.main[0].name
  security_group_ids   = [aws_security_group.redis[0].id]

  # Multi-AZ configuration
  automatic_failover_enabled = var.multi_az_enabled
  num_cache_clusters         = var.multi_az_enabled ? 2 : 1

  # Engine configuration
  engine         = "redis"
  engine_version = var.redis_version

  # Backup configuration
  snapshot_retention_limit = var.snapshot_retention_days
  snapshot_window          = var.snapshot_window

  # Maintenance window
  maintenance_window = var.maintenance_window

  # Tags
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis"
      Type = "Replication Group"
    }
  )

  # Lifecycle
  lifecycle {
    ignore_changes = [
      num_cache_clusters,
      automatic_failover_enabled
    ]
  }
}

# CloudWatch Log Group for Redis logs
resource "aws_cloudwatch_log_group" "redis" {
  count = var.enable_elasticache && var.enable_logging ? 1 : 0

  name              = "/aws/elasticache/${local.name_prefix}-redis"
  retention_in_days = var.log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name = "/aws/elasticache/${local.name_prefix}-redis"
      Type = "Log Group"
    }
  )
}

# CloudWatch Alarms for Redis monitoring
resource "aws_cloudwatch_metric_alarm" "redis_cpu" {
  count = var.enable_elasticache && var.enable_monitoring ? 1 : 0

  alarm_name          = "${local.name_prefix}-redis-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Redis CPU utilization is high"
  alarm_actions       = var.alarm_actions

  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.main[0].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis-cpu-alarm"
      Type = "CloudWatch Alarm"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "redis_memory" {
  count = var.enable_elasticache && var.enable_monitoring ? 1 : 0

  alarm_name          = "${local.name_prefix}-redis-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "Redis memory usage is high"
  alarm_actions       = var.alarm_actions

  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.main[0].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis-memory-alarm"
      Type = "CloudWatch Alarm"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "redis_connections" {
  count = var.enable_elasticache && var.enable_monitoring ? 1 : 0

  alarm_name          = "${local.name_prefix}-redis-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "1000"
  alarm_description   = "Redis connection count is high"
  alarm_actions       = var.alarm_actions

  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.main[0].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-redis-connections-alarm"
      Type = "CloudWatch Alarm"
    }
  )
}
