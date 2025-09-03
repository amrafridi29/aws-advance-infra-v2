# Advanced ElastiCache Module Usage Example
# This example shows advanced configurations with high availability, monitoring, and performance tuning

# Advanced ElastiCache Module Configuration
module "elasticache_advanced" {
  source = "../../elasticache"

  # Required variables
  project_name = "myapp"
  environment  = "production"

  # Network configuration
  vpc_id = "vpc-12345678"
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321",
    "subnet-11111111"
  ]

  # Security configuration
  allowed_security_group_ids = [
    "sg-12345678", # Application security group
    "sg-87654321"  # Monitoring security group
  ]

  # Performance configuration
  node_type        = "cache.r5.large"
  multi_az_enabled = true

  # Redis configuration for high performance
  redis_parameters = [
    {
      name  = "maxmemory-policy"
      value = "allkeys-lru"
    },
    {
      name  = "notify-keyspace-events"
      value = "Ex"
    },
    {
      name  = "timeout"
      value = "300"
    },
    {
      name  = "tcp-keepalive"
      value = "300"
    },
    {
      name  = "maxmemory-samples"
      value = "5"
    }
  ]

  # High availability configuration
  snapshot_retention_days = 14
  snapshot_window         = "02:00-03:00"
  maintenance_window      = "sun:03:00-sun:04:00"

  # Monitoring and alerting
  enable_monitoring  = true
  enable_logging     = true
  log_retention_days = 90
  alarm_actions = [
    "arn:aws:sns:us-east-1:123456789012:my-notifications-topic"
  ]

  # Advanced tagging strategy
  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
    CostCenter  = "IT-Infrastructure"
    ManagedBy   = "Terraform"
    Purpose     = "Caching"
    Component   = "ElastiCache"
    Tier        = "Performance"
  }
}

# Custom CloudWatch Dashboard for Redis monitoring
resource "aws_cloudwatch_dashboard" "redis" {
  dashboard_name = "myapp-redis-monitoring"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ElastiCache", "CPUUtilization", "CacheClusterId", module.elasticache_advanced.elasticache_cluster_id],
            [".", "DatabaseMemoryUsagePercentage", ".", "."],
            [".", "CurrConnections", ".", "."],
            [".", "CacheHits", ".", "."],
            [".", "CacheMisses", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Redis Performance Metrics"
        }
      }
    ]
  })
}

# Additional CloudWatch Alarms for advanced monitoring
resource "aws_cloudwatch_metric_alarm" "redis_cache_hit_rate" {
  alarm_name          = "myapp-redis-cache-hit-rate-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CacheHitRate"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Redis cache hit rate is low"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:my-notifications-topic"]

  dimensions = {
    CacheClusterId = module.elasticache_advanced.elasticache_cluster_id
  }

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Cache Performance Monitoring"
  }
}

resource "aws_cloudwatch_metric_alarm" "redis_evictions" {
  alarm_name          = "myapp-redis-evictions-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Sum"
  threshold           = "100"
  alarm_description   = "Redis evictions are high"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:my-notifications-topic"]

  dimensions = {
    CacheClusterId = module.elasticache_advanced.elasticache_cluster_id
  }

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Cache Performance Monitoring"
  }
}

# IAM role for application access to Redis
resource "aws_iam_role" "redis_access" {
  name = "myapp-redis-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "production"
    Project     = "myapp"
    Purpose     = "Redis Access"
  }
}

resource "aws_iam_role_policy" "redis_access" {
  name = "myapp-redis-access-policy"
  role = aws_iam_role.redis_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeCacheParameters",
          "elasticache:DescribeCacheSubnetGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

# Outputs for advanced configuration
output "elasticache_advanced_outputs" {
  description = "Advanced ElastiCache module outputs"
  value = {
    # Basic module outputs
    cluster_id          = module.elasticache_advanced.elasticache_cluster_id
    endpoint            = module.elasticache_advanced.elasticache_endpoint
    port                = module.elasticache_advanced.elasticache_port
    connection_string   = module.elasticache_advanced.elasticache_connection_string
    security_group_id   = module.elasticache_advanced.elasticache_security_group_id
    elasticache_summary = module.elasticache_advanced.elasticache_summary

    # Advanced outputs
    reader_endpoint      = module.elasticache_advanced.elasticache_reader_endpoint
    subnet_group_name    = module.elasticache_advanced.elasticache_subnet_group_name
    parameter_group_name = module.elasticache_advanced.elasticache_parameter_group_name
    log_group_name       = module.elasticache_advanced.elasticache_log_group_name
    alarm_names          = module.elasticache_advanced.elasticache_alarm_names

    # Custom resources
    dashboard_name        = aws_cloudwatch_dashboard.redis.dashboard_name
    redis_access_role_arn = aws_iam_role.redis_access.arn
  }
}

# Data source for existing SNS topic (if not created by this module)
data "aws_sns_topic" "notifications" {
  name = "my-notifications-topic"
}
