# 🚀 AWS Advanced Infrastructure with Terraform

A production-ready, industry-standard AWS infrastructure built with Terraform, featuring modular design, multi-environment support, and enterprise-grade security.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Module Documentation](#module-documentation)
- [Environments](#environments)
- [Deployment Guide](#deployment-guide)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🎯 Overview

This project provides a complete, production-ready AWS infrastructure using Infrastructure as Code (IaC) with Terraform. It follows industry best practices including:

- **Modular Design**: Reusable, maintainable Terraform modules
- **Multi-Environment Support**: Staging and production environments
- **Security First**: IAM, KMS, VPC, and security groups
- **Scalable Compute**: ECS Fargate with auto-scaling
- **Monitoring & Logging**: CloudWatch, CloudTrail, and VPC Flow Logs
- **Container Registry**: ECR with lifecycle policies and image scanning

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Global Backend                           │
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │   S3 Bucket     │    │        DynamoDB Table           │ │
│  │  (State Files)  │    │      (State Locking)            │ │
│  └─────────────────┘    └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Environment Layer                           │
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │    Staging      │    │         Production              │ │
│  │   Environment   │    │        Environment              │ │
│  └─────────────────┘    └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                  Module Layer                                  │
│  ┌─────────┐ ┌──────────┐ ┌─────────┐ ┌──────────┐ ┌─────────┐ │
│  │ Backend │ │Networking│ │Security │ │Monitoring│ │ Compute │ │
│  │         │ │          │ │         │ │          │ │         │ │
│  └─────────┘ └──────────┘ └─────────┘ └──────────┘ └─────────┘ │
│  ┌─────────┐ ┌──────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│  │   IAM   │ │Encryption│ │ Storage │ │   ECR   │ │Rollback │  │
│  │         │ │          │ │         │ │         │ │         │  │
│  └─────────┘ └──────────┘ └─────────┘ └─────────┘ └─────────┘  │
└────────────────────────────────────────────────────────────────┘
```

## ✨ Features

### 🔐 **Security & Compliance**

- **VPC with Private/Public Subnets**: Network isolation and security
- **Security Groups**: Stateful traffic filtering
- **IAM Roles & Policies**: Least privilege access control
- **KMS Encryption**: Data encryption at rest and in transit
- **VPC Flow Logs**: Network traffic monitoring
- **CloudTrail**: API call logging and auditing

### 🚀 **Compute & Scalability**

- **ECS Fargate**: Serverless container orchestration
- **Auto Scaling**: CPU, memory, and scheduled scaling
- **Load Balancer**: Application Load Balancer with health checks
- **Service Discovery**: Inter-service communication

### 📊 **Monitoring & Observability**

- **CloudWatch Logs**: Centralized logging
- **CloudWatch Metrics**: Performance monitoring
- **CloudWatch Alarms**: Automated alerting
- **VPC Flow Logs**: Network traffic analysis

### 🗄️ **Storage & Data**

- **S3 Buckets**: Object storage with lifecycle policies
- **RDS MySQL**: Managed relational database
- **ElastiCache Redis**: In-memory caching
- **EBS Volumes**: Block storage for compute instances

### 🐳 **Container Management**

- **ECR Repositories**: Private container registry
- **Image Scanning**: Security vulnerability detection
- **Lifecycle Policies**: Automatic image cleanup
- **Multi-container Tasks**: Sidecar pattern support

## 📋 Prerequisites

### **Required Tools**

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) >= 2.0
- [Docker](https://www.docker.com/products/docker-desktop) (for container builds)

### **AWS Requirements**

- AWS Account with appropriate permissions
- IAM user with programmatic access
- S3 bucket for Terraform state files
- DynamoDB table for state locking

### **Git Setup**

- Git repository initialized
- Proper branch structure (main, develop)

## 🚀 Quick Start

### **1. Clone and Setup**

```bash
git clone <your-repo-url>
cd aws-advance-infra
```

### **2. Configure Backend**

```bash
cd backend
terraform init
terraform apply
```

### **3. Deploy Staging Environment**

```bash
cd ../environments/staging
terraform init
terraform apply
```

### **4. Deploy Production Environment**

```bash
cd ../environments/production
terraform init
terraform apply
```

## 📚 Module Documentation

### **Backend Module** (`modules/backend/`)

- **Purpose**: Global S3 backend and DynamoDB state locking
- **Resources**: S3 bucket, DynamoDB table, IAM policies
- **Usage**: Deployed once globally, referenced by all environments

### **Networking Module** (`modules/networking/`)

- **Purpose**: VPC, subnets, routing, and load balancing
- **Resources**: VPC, subnets, IGW, NAT Gateway, ALB, Target Groups
- **Features**: Multi-AZ deployment, public/private subnet separation

### **Security Module** (`modules/security/`)

- **Purpose**: Security groups, IAM roles, and KMS encryption
- **Resources**: Security groups, IAM roles, KMS keys, VPC Flow Logs
- **Features**: Least privilege access, encryption at rest

### **Monitoring Module** (`modules/monitoring/`)

- **Purpose**: CloudWatch resources and logging
- **Resources**: Log groups, CloudTrail, SNS topics
- **Features**: Centralized logging, audit trails

### **IAM Module** (`modules/iam/`)

- **Purpose**: Identity and access management
- **Resources**: ECS task roles, execution roles, policies
- **Features**: Service-specific permissions

### **Encryption Module** (`modules/encryption/`)

- **Purpose**: Key management and encryption
- **Resources**: KMS keys, aliases, policies
- **Features**: Customer-managed keys, encryption policies

### **Storage Module** (`modules/storage/`)

- **Purpose**: Data storage and caching
- **Resources**: S3 buckets, RDS instances, ElastiCache
- **Features**: Lifecycle policies, backup strategies

### **Compute Module** (`modules/compute/`)

- **Purpose**: ECS cluster and service management
- **Resources**: ECS cluster, services, task definitions
- **Features**: Auto-scaling, health checks, multi-container support

### **ECR Module** (`modules/ecr/`)

- **Purpose**: Container image management
- **Resources**: ECR repositories, lifecycle policies
- **Features**: Image scanning, automatic cleanup

## 🌍 Environments

### **Staging Environment** (`environments/staging/`)

- **Purpose**: Development and testing
- **Features**: Full infrastructure with reduced resources
- **Deployment**: Automatic on develop branch
- **URL**: `http://aws-advance-infra-staging-alb-*.elb.amazonaws.com`

### **Production Environment** (`environments/production/`)

- **Purpose**: Live production workloads
- **Features**: High availability, enhanced security
- **Deployment**: Manual approval required
- **URL**: Custom domain (configure as needed)

## 📖 Deployment Guide

### **Phase 1: Backend Infrastructure**

```bash
cd backend
terraform init
terraform plan
terraform apply
```

### **Phase 2: Staging Environment**

```bash
cd ../environments/staging
terraform init
terraform plan
terraform apply
```

### **Phase 3: Production Environment**

```bash
cd ../environments/production
terraform init
terraform plan
terraform apply
```

### **Phase 4: Application Deployment**

```bash
# Push images to ECR
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-2.amazonaws.com

# Build and push frontend
docker build -t <account-id>.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend:latest frontend/
docker push <account-id>.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend:latest

# Build and push backend
docker build -t <account-id>.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-backend:latest backend/
docker push <account-id>.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-backend:latest
```

## 💡 Usage Examples

### **Basic Usage**

```hcl
# environments/staging/main.tf
module "networking" {
  source = "../../modules/networking"

  vpc_cidr = "10.0.0.0/16"
  environment = "staging"
  enable_load_balancer = true
}

module "compute" {
  source = "../../modules/compute"

  vpc_id = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  target_group_arn = module.networking.target_group_arn
}
```

### **Advanced Usage**

```hcl
# Advanced ECS configuration
module "compute" {
  source = "../../modules/compute"

  containers = [
    {
      name = "frontend"
      image = "your-registry/frontend:latest"
      port = 80
      cpu = 512
      memory = 1024
      health_check = {
        command = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1"]
        interval = 30
        timeout = 5
        retries = 3
      }
    }
  ]

  enable_auto_scaling = true
  min_capacity = 1
  max_capacity = 5
  scheduled_scaling = [
    {
      name = "scale-up-morning"
      schedule = "cron(0 8 * * ? *)"
      min_capacity = 2
      max_capacity = 5
    }
  ]
}
```

## 🔧 Troubleshooting

### **Common Issues**

#### **Terraform State Lock**

```bash
# If DynamoDB table is locked
aws dynamodb delete-item \
  --table-name terraform-state-lock \
  --key '{"LockID": {"S": "your-bucket-name/your-key"}}'
```

#### **ECS Service Issues**

```bash
# Check service events
aws ecs describe-services \
  --cluster aws-advance-infra-staging-cluster \
  --services aws-advance-infra-staging-service

# Check task logs
aws logs describe-log-groups --log-group-name-prefix /ecs/
```

#### **Load Balancer Health Checks**

```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn>
```

### **Debug Commands**

```bash
# Validate Terraform configuration
terraform validate

# Check Terraform plan
terraform plan -out=tfplan

# View detailed plan
terraform show tfplan

# Check AWS resources
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=*staging*"
```

## 🤝 Contributing

### **Development Workflow**

1. Create feature branch from `develop`
2. Make changes and test in staging
3. Create pull request to `develop`
4. After testing, merge to `main` for production

### **Code Standards**

- Use consistent Terraform formatting (`terraform fmt`)
- Follow naming conventions
- Add proper documentation
- Test changes in staging first

### **Module Development**

- Keep modules generic and reusable
- Use variables for configuration
- Provide comprehensive outputs
- Include usage examples

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- HashiCorp for Terraform
- AWS for cloud infrastructure
- Open source community for best practices

---

## 📞 Support

For questions or issues:

- Create an issue in the repository
- Check the troubleshooting section
- Review module documentation
- Consult AWS and Terraform documentation

**Happy Infrastructure Building! 🚀**
