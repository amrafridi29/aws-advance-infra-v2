# Production Environment - Main Configuration
# This file orchestrates the deployment of all infrastructure components for production

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration - will be configured after backend deployment
  # Uncomment and configure after backend infrastructure is deployed
  backend "s3" {
    bucket         = "terraform-state-398512629816-us-east-2"
    key            = "environments/production/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks-398512629816-us-east-2"
    encrypt        = true
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Purpose     = "Production Infrastructure"
    }
  }
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

# Load balancer data source for CloudFront
data "aws_lb" "production" {
  name       = "${var.project_name}-${var.environment}-alb"
  depends_on = [module.networking]
}

# Data sources to fetch manually created Parameter Store parameters
data "aws_ssm_parameter" "backend_env_vars" {
  for_each = toset([
    "PORT",
    "DB_HOST",
    "DB_PORT",
  ])

  name = "/${var.project_name}/${var.environment}/backend/${each.value}"
}

# Local values for consistent naming and configuration
locals {
  environment = var.environment

  # Availability zones (limit to 2 for cost optimization in production)
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # Container configuration flags
  enable_frontend_container = var.enable_frontend_container
  enable_backend_container  = var.enable_backend_container # Set to false when only frontend is ready

  # Custom domain configuration
  custom_domains = var.custom_domains
  base_domain    = var.base_domain
  subdomain      = var.subdomain

  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Purpose     = "Production Infrastructure"
    Owner       = var.team_name
    CostCenter  = var.cost_center
  }

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# Networking Module - This is where we USE our module!
module "networking" {
  source = "../../modules/networking"

  # Module variables
  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  project_name         = var.project_name
  availability_zones   = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # Optional networking features
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  # Load Balancer Configuration
  enable_load_balancer            = true
  load_balancer_name              = "${var.project_name}-${var.environment}-alb"
  enable_https                    = false
  certificate_arn                 = ""
  load_balancer_security_group_id = module.security.load_balancer_security_group_id

  # Target Group Configuration
  target_group_name     = "${var.project_name}-${var.environment}-tg"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  health_check_path     = "/"
  health_check_interval = 30
  health_check_timeout  = 5
  healthy_threshold     = 2
  unhealthy_threshold   = 2

  # Tags
  tags = local.common_tags
}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  environment  = var.environment
  project_name = var.project_name

  # IAM Roles
  create_app_role                = true
  create_admin_role              = false
  create_service_role            = false
  create_ecs_task_execution_role = true

  # VPC Flow Log Role (required for monitoring)
  create_vpc_flow_log_role = true

  # GitHub OIDC Configuration
  enable_github_oidc  = var.enable_github_oidc
  frontend_repository = var.frontend_repository
  backend_repository  = var.backend_repository
  allowed_branches    = var.allowed_branches

  tags = local.common_tags
}

# Encryption Module
module "encryption" {
  source = "../../modules/encryption"

  environment  = var.environment
  project_name = var.project_name

  # Basic encryption
  enable_kms_encryption = true

  tags = local.common_tags
}

# Storage Module
module "storage" {
  source = "../../modules/storage"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.private_subnet_ids

  # S3 Storage
  enable_s3_storage = true

  # RDS Database (disabled for production - requires password)
  enable_rds            = false
  rds_instance_class    = "db.t3.micro"
  rds_engine            = "mysql"
  rds_engine_version    = "8.0"
  rds_allocated_storage = 5
  rds_database_name     = "staging_db"
  rds_username          = "staging_user"
  rds_password          = "db-password"

  # ElastiCache (disabled for production)
  enable_elasticache = false

  # EBS Volumes (disabled for production)
  enable_ebs = false

  # Encryption
  kms_key_arn = module.encryption.main_key_arn

  tags = local.common_tags
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"

  environment  = var.environment
  project_name = var.project_name

  # Enable both repositories
  enable_frontend_repository = true
  enable_backend_repository  = true

  # Features
  enable_image_scanning     = true
  enable_lifecycle_policies = true
  max_image_count           = 10

  # Tags
  tags = local.common_tags
}

# CloudFront Module
module "cloudfront" {
  source = "../../modules/cloudfront"

  project_name       = var.project_name
  environment        = var.environment
  origin_domain_name = data.aws_lb.production.dns_name
  origin_id          = "alb-origin"
  origin_type        = "alb"

  # Custom domain configuration (temporarily disabled until manual SSL certificate is created)
  custom_domain_names = local.custom_domains
  ssl_certificate_arn = var.ssl_certificate_arn

  # Performance settings
  compress    = true
  enable_ipv6 = true
  price_class = "PriceClass_100" # North America and Europe

  # Cache settings
  min_ttl     = 0    # No cache for dynamic content
  default_ttl = 300  # 5 minutes default
  max_ttl     = 3600 # 1 hour maximum

  # Security settings
  enable_security_headers = true
  viewer_protocol_policy  = "allow-all"

  # Custom cache behaviors for static assets
  custom_cache_behaviors = [
    {
      path_pattern           = "/api/*"
      allowed_methods        = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "alb-origin"
      forward_query_string   = true
      forward_cookies        = "all"
      min_ttl                = 0 # No cache for API calls
      default_ttl            = 0 # No cache for API calls
      max_ttl                = 0 # No cache for API calls
      compress               = true
      viewer_protocol_policy = "allow-all"
    },
    {
      path_pattern           = "/assets/*"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "alb-origin"
      forward_query_string   = false
      forward_cookies        = "none"
      min_ttl                = 86400    # 1 day
      default_ttl            = 604800   # 1 week
      max_ttl                = 31536000 # 1 year
      compress               = true
      viewer_protocol_policy = "allow-all"
    },
    {
      path_pattern           = "/*.js"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "alb-origin"
      forward_query_string   = false
      forward_cookies        = "none"
      min_ttl                = 86400    # 1 day
      default_ttl            = 604800   # 1 week
      max_ttl                = 31536000 # 1 year
      compress               = true
      viewer_protocol_policy = "allow-all"
    },
    {
      path_pattern           = "/*.css"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "alb-origin"
      forward_query_string   = false
      forward_cookies        = "none"
      min_ttl                = 86400    # 1 day
      default_ttl            = 604800   # 1 week
      max_ttl                = 31536000 # 1 year
      compress               = true
      viewer_protocol_policy = "allow-all"
    }
  ]

  # Custom error responses for SPA
  custom_error_responses = [
    {
      error_code            = 404
      response_code         = "200"
      response_page_path    = "/index.html"
      error_caching_min_ttl = 300
    }
  ]

  tags = local.common_tags

  depends_on = [module.networking, data.aws_lb.production]
}

# Security Module
module "security" {
  source = "../../modules/security"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id

  # Security Groups
  create_security_groups = true
  allowed_cidr_blocks    = var.allowed_cidr_blocks
  enable_ssh_access      = false # Disable SSH for production security
  enable_http_access     = true  # Enable HTTP for production
  enable_https_access    = true  # Enable HTTPS for production
  enable_database_access = true  # Enable database access
  database_port          = 3306  # Default MySQL port

  tags = local.common_tags
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id

  # Subnet Configuration
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  # ECS Configuration
  enable_ecs = true

  # ECS Service
  enable_ecs_service = true

  # ECS Task Configuration
  ecs_task_cpu    = 1024 # 1 vCPU for both containers
  ecs_task_memory = 2048 # 2 GB for both containers

  # Advanced ECS Container Configuration
  containers = concat(
    # Frontend container (always enabled)
    local.enable_frontend_container ? [
      {
        name      = "frontend"
        image     = "398512629816.dkr.ecr.us-east-2.amazonaws.com/${var.project_name}-${var.environment}-frontend:latest"
        port      = 80
        protocol  = "tcp"
        essential = true
        environment = [
          {
            name  = "ENVIRONMENT"
            value = "production"
          },
          {
            name  = "APP_VERSION"
            value = "1.0.0"
          }
        ]
        health_check = {
          command     = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1"]
          interval    = 30
          timeout     = 5
          retries     = 3
          startPeriod = 60
        }
      }
    ] : [],
    # Backend container (optional)
    local.enable_backend_container ? [
      {
        name      = "backend"
        image     = "398512629816.dkr.ecr.us-east-2.amazonaws.com/${var.project_name}-${var.environment}-backend:latest"
        port      = 3001
        protocol  = "tcp"
        essential = false # Make backend non-essential so frontend can run without it
        environment = [
          {
            name  = "ENVIRONMENT"
            value = "production"
          },
          {
            name  = "APP_VERSION"
            value = "1.0.0"
          }
        ]
        secrets = [
          {
            name      = "PORT"
            valueFrom = data.aws_ssm_parameter.backend_env_vars["PORT"].arn
          },
          {
            name      = "DB_HOST"
            valueFrom = data.aws_ssm_parameter.backend_env_vars["DB_HOST"].arn
          },
          {
            name      = "DB_PORT"
            valueFrom = data.aws_ssm_parameter.backend_env_vars["DB_PORT"].arn
          },
        ]
        health_check = {
          command     = ["CMD-SHELL", "curl -f http://localhost:3001/api/health || exit 1"]
          interval    = 30
          timeout     = 5
          retries     = 3
          startPeriod = 60
        }
      }
    ] : []
  )

  # ECS Service Configuration
  ecs_desired_count = 1

  # Load Balancer Integration
  enable_load_balancer_integration = true
  target_group_arn                 = module.networking.target_group_arn

  # Enable ECS Exec for debugging
  enable_execute_command = true

  # Service Discovery (disabled for production)
  enable_service_discovery = false

  # Advanced Auto Scaling Configuration
  enable_auto_scaling = var.enable_auto_scaling
  min_capacity        = var.min_capacity
  max_capacity        = var.max_capacity



  # Scheduled scaling for business hours
  scheduled_scaling = [
    {
      schedule     = "cron(0 8 * * ? *)" # 8 AM daily
      min_capacity = 2
      max_capacity = 4
    },
    {
      schedule     = "cron(0 18 * * ? *)" # 6 PM daily
      min_capacity = 1
      max_capacity = 2
    }
  ]

  # Security Groups
  ecs_service_security_group_id = module.security.app_security_group_id

  # IAM Roles
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_execution_role_arn # Temporarily use execution role to resolve validation

  tags = local.common_tags
}

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id

  # VPC Flow Logs
  enable_vpc_flow_logs      = var.enable_flow_logs
  vpc_flow_log_iam_role_arn = module.iam.vpc_flow_log_role_arn

  # CloudWatch Logs
  enable_cloudwatch_logs = var.enable_cloudwatch_logs

  # CloudTrail (disabled for production - requires S3 bucket)
  enable_cloudtrail = false

  # Alarms and Dashboards (optional for production)
  enable_alarms     = false
  enable_dashboards = false

  # ECS Log Groups (enabled for production)
  enable_ecs_log_groups = true
  ecs_log_groups = [
    {
      name              = "/ecs/${var.project_name}-${var.environment}-task"
      retention_in_days = 30
      kms_key_arn       = "" # Disable KMS encryption temporarily
    }
  ]

  # ECR Scan Events and Notifications
  enable_ecr_scan_events  = true
  ecr_notification_emails = var.ecr_notification_emails
  ecr_security_emails     = var.ecr_security_emails

  tags = local.common_tags
}

# Route 53 Module
# module "route53" {
#   source = "../../modules/route53"

#   environment  = var.environment
#   project_name = var.project_name
#   domain_name  = local.base_domain
#   subdomain    = local.subdomain

#   # CloudFront configuration (enabled with custom domain)
#   create_cloudfront_record = true
#   cloudfront_domain_name   = module.cloudfront.distribution_domain_name

#   # Multiple domains for CloudFront (both production and www.production)
#   cloudfront_domains = local.custom_domains

#   # Load balancer configuration (optional)
#   create_load_balancer_record = false

#   tags = local.common_tags

#   depends_on = [module.cloudfront]
# }

# ElastiCache Module
module "elasticache" {
  source = "../../modules/elasticache"

  project_name = var.project_name
  environment  = var.environment

  enable_elasticache = var.enable_elasticache

  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids

  allowed_security_group_ids = [module.security.app_security_group_id]

  # Performance configuration for production
  node_type        = "cache.t3.small"
  multi_az_enabled = false # Enable for high availability if needed

  # Redis configuration
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
    }
  ]

  # Monitoring and alerting
  enable_monitoring = true
  enable_logging    = true
  alarm_actions     = [module.monitoring.ecr_notifications_topic_arn]

  # Backup configuration
  snapshot_retention_days = 7
  snapshot_window         = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  tags = local.common_tags
}

# Outputs are defined in outputs.tf
