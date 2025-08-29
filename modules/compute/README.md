# ECS Compute Module

This module creates comprehensive ECS (Elastic Container Service) infrastructure for running containerized applications with auto-scaling, load balancing, and service discovery.

## 🎯 Purpose

The ECS compute module provides:

- **ECS Cluster**: Container orchestration platform
- **ECS Services**: Application deployments with auto-scaling
- **Task Definitions**: Container specifications and configurations
- **Application Load Balancer**: Traffic distribution and health checks
- **Service Discovery**: Internal service communication
- **Auto Scaling**: Automatic scaling based on demand
- **Container Logging**: CloudWatch integration for logs

## 🏗️ Architecture

```
ECS Compute Module
├── ECS Cluster
│   ├── Cluster Configuration
│   ├── Capacity Providers
│   └── Cluster Settings
├── ECS Services
│   ├── Application Services
│   ├── Worker Services
│   └── Scheduled Tasks
├── Task Definitions
│   ├── Container Definitions
│   ├── Task Role & Execution Role
│   └── Resource Requirements
├── Load Balancing
│   ├── Application Load Balancer
│   ├── Target Groups
│   └── Listener Rules
├── Service Discovery
│   ├── Private DNS Namespace
│   └── Service Discovery Services
└── Auto Scaling
    ├── ECS Service Scaling
    ├── Target Tracking Policies
    └── Scheduled Scaling
```

## 📦 Resources Created

### ECS Infrastructure

- **ECS Cluster**: Main container orchestration platform
- **Capacity Providers**: FARGATE and FARGATE_SPOT for serverless compute
- **Cluster Settings**: Logging, monitoring, and security configurations

### ECS Services

- **Application Services**: Web applications with load balancer integration
- **Worker Services**: Background processing tasks
- **Scheduled Tasks**: Cron-based job execution

### Load Balancing

- **Application Load Balancer**: HTTP/HTTPS traffic distribution
- **Target Groups**: Health checks and routing rules
- **Listener Rules**: Path-based routing and SSL termination

### Service Discovery

- **Private DNS Namespace**: Internal service communication
- **Service Discovery Services**: Service-to-service communication

### Auto Scaling

- **Target Tracking**: CPU and memory-based scaling
- **Scheduled Scaling**: Time-based scaling policies
- **Step Scaling**: Custom scaling policies

## 🚀 Usage

### Basic Usage

```hcl
module "compute" {
  source = "../../modules/compute"

  environment    = "staging"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  # ECS Configuration
  enable_ecs = true

  # Load Balancer
  enable_load_balancer = true

  # Service Discovery
  enable_service_discovery = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "compute" {
  source = "../../modules/compute"

  environment    = "production"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  # ECS Configuration
  enable_ecs = true
  ecs_cluster_name = "production-cluster"
  ecs_capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  # Load Balancer with SSL
  enable_load_balancer = true
  enable_https = true
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id"

  # Auto Scaling
  enable_auto_scaling = true
  min_capacity = 2
  max_capacity = 10

  # Service Discovery
  enable_service_discovery = true
  service_discovery_namespace = "internal.production.local"

  tags = {
    Environment = "production"
    Project     = "my-project"
    Compliance  = "SOC2"
  }
}
```

## 📋 Input Variables

### Required Variables

- `environment`: Environment name (e.g., staging, production)
- `project_name`: Name of the project
- `vpc_id`: ID of the VPC for ECS cluster
- `public_subnet_ids`: List of public subnet IDs for load balancer
- `private_subnet_ids`: List of private subnet IDs for ECS services

### Optional Variables

- `enable_ecs`: Whether to create ECS infrastructure
- `enable_load_balancer`: Whether to create load balancer
- `enable_service_discovery`: Whether to enable service discovery
- `enable_auto_scaling`: Whether to enable auto-scaling
- `ecs_cluster_name`: Name for the ECS cluster
- `ecs_capacity_providers`: List of capacity providers
- `enable_https`: Whether to enable HTTPS on load balancer
- `certificate_arn`: ARN of SSL certificate for HTTPS
- `min_capacity`: Minimum number of tasks for auto-scaling
- `max_capacity`: Maximum number of tasks for auto-scaling

## 📤 Outputs

- `ecs_cluster_arn`: ARN of the ECS cluster
- `ecs_cluster_name`: Name of the ECS cluster
- `load_balancer_arn`: ARN of the application load balancer
- `load_balancer_dns_name`: DNS name of the load balancer
- `target_group_arns`: List of target group ARNs
- `service_discovery_namespace_id`: ID of the service discovery namespace
- `compute_summary`: Summary of the compute infrastructure

## 🔒 Security Features

- **Network Security**: Services deployed in private subnets
- **IAM Integration**: Task execution and task roles
- **Security Groups**: Network-level access control
- **Encryption**: In-transit and at-rest encryption
- **VPC Isolation**: Complete network isolation

## 💰 Cost Optimization

- **FARGATE_SPOT**: Use spot capacity for cost savings
- **Auto Scaling**: Scale down during low usage
- **Resource Optimization**: Right-size task definitions
- **Load Balancer**: Efficient traffic distribution

## 🧪 Testing

### Test Scenarios

1. **Container Deployment**: Verify containers deploy successfully
2. **Load Balancing**: Test traffic distribution and health checks
3. **Auto Scaling**: Verify scaling based on load
4. **Service Discovery**: Test internal service communication
5. **Monitoring**: Verify CloudWatch integration

### Validation Rules

- All containers must be in private subnets
- Load balancer must be in public subnets
- Security groups must restrict access appropriately
- Auto-scaling policies must be properly configured

## 📚 Dependencies

- AWS Provider
- VPC ID from networking module
- Subnet IDs from networking module
- Security group IDs from security module
- IAM role ARNs from IAM module

## 🔄 Updates and Maintenance

- **Service Updates**: Rolling deployments with zero downtime
- **Scaling**: Automatic scaling based on demand
- **Monitoring**: Real-time performance monitoring
- **Logging**: Centralized container logging
