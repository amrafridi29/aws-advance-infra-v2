# 🚀 Deployment Guide

## 📋 Overview

This guide provides step-by-step instructions for deploying the AWS Advanced Infrastructure using Terraform. Follow these steps carefully to ensure a successful deployment.

## 🎯 Prerequisites

### **Required Tools**

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) >= 2.0
- [Docker](https://www.docker.com/products/docker-desktop) (for container builds)
- [Git](https://git-scm.com/) for version control

### **AWS Setup**

1. **AWS Account**: Active AWS account with appropriate permissions
2. **IAM User**: Create a user with programmatic access
3. **Access Keys**: Generate access key and secret access key
4. **Permissions**: Ensure the user has necessary permissions

### **Required IAM Permissions**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "dynamodb:*",
        "ec2:*",
        "ecs:*",
        "ecr:*",
        "iam:*",
        "kms:*",
        "rds:*",
        "elasticache:*",
        "logs:*",
        "cloudtrail:*",
        "sns:*",
        "autoscaling:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
```

### **Environment Variables**

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-2"
```

## 🏗️ Deployment Phases

### **Phase 1: Backend Infrastructure** ⭐ **REQUIRED FIRST**

The backend infrastructure must be deployed first as it provides the S3 bucket and DynamoDB table for Terraform state management.

#### **1.1 Navigate to Backend Directory**

```bash
cd backend
```

#### **1.2 Initialize Terraform**

```bash
terraform init
```

#### **1.3 Review the Plan**

```bash
terraform plan
```

**Expected Output:**

```
Plan: 3 to add, 0 to change, 0 to destroy.

Changes to be made:
  + aws_s3_bucket.terraform_state
  + aws_s3_bucket_versioning.terraform_state
  + aws_dynamodb_table.terraform_locks
```

#### **1.4 Apply Backend Infrastructure**

```bash
terraform apply
```

**Expected Output:**

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:
s3_bucket_name = "aws-advance-infra-terraform-state-123456789012"
dynamodb_table_name = "terraform-state-lock"
```

#### **1.5 Verify Backend Resources**

```bash
# Verify S3 bucket
aws s3 ls s3://aws-advance-infra-terraform-state-123456789012

# Verify DynamoDB table
aws dynamodb describe-table --table-name terraform-state-lock
```

### **Phase 2: Staging Environment** 🧪

#### **2.1 Navigate to Staging Directory**

```bash
cd ../environments/staging
```

#### **2.2 Initialize Terraform with Backend**

```bash
terraform init \
  -backend-config="bucket=aws-advance-infra-terraform-state-123456789012" \
  -backend-config="key=staging/terraform.tfstate" \
  -backend-config="region=us-east-2" \
  -backend-config="dynamodb_table=terraform-state-lock"
```

#### **2.3 Review the Plan**

```bash
terraform plan
```

**Expected Output:**

```
Plan: 45 to add, 0 to change, 0 to destroy.

Changes to be made:
  + module.backend
  + module.networking
  + module.security
  + module.monitoring
  + module.iam
  + module.encryption
  + module.storage
  + module.compute
  + module.ecr
  ...
```

#### **2.4 Apply Staging Infrastructure**

```bash
terraform apply
```

**Expected Output:**

```
Apply complete! Resources: 45 added, 0 changed, 0 destroyed.

Outputs:
vpc_id = "vpc-12345678"
load_balancer_dns_name = "aws-advance-infra-staging-alb-123456789.us-east-2.elb.amazonaws.com"
ecr_outputs = {
  "frontend_repository_url" = "123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend"
  "backend_repository_url" = "123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-backend"
}
```

#### **2.5 Verify Staging Deployment**

```bash
# Check VPC
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=aws-advance-infra-staging-vpc"

# Check ECS Cluster
aws ecs describe-clusters --clusters aws-advance-infra-staging-cluster

# Check Load Balancer
aws elbv2 describe-load-balancers --names aws-advance-infra-staging-alb

# Check ECR Repositories
aws ecr describe-repositories --repository-names aws-advance-infra-staging-frontend
aws ecr describe-repositories --repository-names aws-advance-infra-staging-backend
```

### **Phase 3: Production Environment** 🚀

#### **3.1 Navigate to Production Directory**

```bash
cd ../production
```

#### **3.2 Initialize Terraform with Backend**

```bash
terraform init \
  -backend-config="bucket=aws-advance-infra-terraform-state-123456789012" \
  -backend-config="key=production/terraform.tfstate" \
  -backend-config="region=us-east-2" \
  -backend-config="dynamodb_table=terraform-state-lock"
```

#### **3.3 Review the Plan**

```bash
terraform plan
```

#### **3.4 Apply Production Infrastructure**

```bash
terraform apply
```

**⚠️ Production Warning:**

- Review the plan carefully before applying
- Ensure all staging tests have passed
- Consider using `terraform plan -out=tfplan` and `terraform apply tfplan`

### **Phase 4: Application Deployment** 🐳

#### **4.1 Login to ECR**

```bash
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-2.amazonaws.com
```

#### **4.2 Build and Push Frontend Image**

```bash
# Navigate to your frontend repository
cd /path/to/your/frontend-repo

# Build the image
docker build -t aws-advance-infra-staging-frontend .

# Tag for ECR
docker tag aws-advance-infra-staging-frontend:latest 123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend:latest

# Push to ECR
docker push 123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend:latest
```

#### **4.3 Build and Push Backend Image**

```bash
# Navigate to your backend repository
cd /path/to/your/backend-repo

# Build the image
docker build -t aws-advance-infra-staging-backend .

# Tag for ECR
docker tag aws-advance-infra-staging-backend:latest 123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-backend:latest

# Push to ECR
docker push 123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-backend:latest
```

#### **4.4 Update ECS Service**

```bash
# Force new deployment
aws ecs update-service \
  --cluster aws-advance-infra-staging-cluster \
  --service aws-advance-infra-staging-service \
  --force-new-deployment
```

#### **4.5 Monitor Deployment**

```bash
# Watch service events
aws ecs describe-services \
  --cluster aws-advance-infra-staging-cluster \
  --services aws-advance-infra-staging-service

# Wait for service to stabilize
aws ecs wait services-stable \
  --cluster aws-advance-infra-staging-cluster \
  --services aws-advance-infra-staging-service
```

## 🔧 Configuration Management

### **Environment-Specific Variables**

#### **Staging Configuration** (`environments/staging/terraform.tfvars`)

```hcl
environment = "staging"
vpc_cidr = "10.0.0.0/16"
enable_https = false
kms_key_arn = ""  # Disable KMS for staging
min_capacity = 1
max_capacity = 3
```

#### **Production Configuration** (`environments/production/terraform.tfvars`)

```hcl
environment = "production"
vpc_cidr = "10.1.0.0/16"
enable_https = true
kms_key_arn = "arn:aws:kms:us-east-2:123456789012:key/your-kms-key"
min_capacity = 2
max_capacity = 10
```

### **Module Configuration**

#### **Networking Module**

```hcl
module "networking" {
  source = "../../modules/networking"

  vpc_cidr = var.vpc_cidr
  environment = var.environment
  enable_load_balancer = true
  enable_https = var.enable_https
  certificate_arn = var.certificate_arn

  tags = var.tags
}
```

#### **Compute Module**

```hcl
module "compute" {
  source = "../../modules/compute"

  vpc_id = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  security_group_ids = [module.security.ecs_security_group_id]

  containers = var.containers
  enable_auto_scaling = true
  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  tags = var.tags
}
```

## 📊 Monitoring & Verification

### **Health Checks**

#### **Load Balancer Health**

```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# Expected output: Healthy targets
```

#### **ECS Service Health**

```bash
# Check service status
aws ecs describe-services \
  --cluster aws-advance-infra-staging-cluster \
  --services aws-advance-infra-staging-service

# Check running tasks
aws ecs list-tasks \
  --cluster aws-advance-infra-staging-cluster \
  --service-name aws-advance-infra-staging-service
```

#### **Application Health**

```bash
# Test frontend
curl -f http://aws-advance-infra-staging-alb-123456789.us-east-2.elb.amazonaws.com/

# Test backend (if exposed)
curl -f http://aws-advance-infra-staging-alb-123456789.us-east-2.elb.amazonaws.com/api/health
```

### **Log Monitoring**

#### **ECS Task Logs**

```bash
# Get log group name
aws logs describe-log-groups --log-group-name-prefix /ecs/aws-advance-infra-staging

# View recent logs
aws logs tail /ecs/aws-advance-infra-staging-frontend --follow
```

#### **VPC Flow Logs**

```bash
# Check flow log status
aws ec2 describe-flow-logs --filter "Name=resource-id,Values=vpc-12345678"
```

## 🚨 Troubleshooting

### **Common Issues & Solutions**

#### **1. Terraform State Lock**

```bash
# Error: Error acquiring the state lock
# Solution: Check if another process is running, or force unlock

# List locks
aws dynamodb scan --table-name terraform-state-lock

# Force unlock (use with caution)
terraform force-unlock <lock-id>
```

#### **2. ECS Service Won't Start**

```bash
# Check service events
aws ecs describe-services \
  --cluster aws-advance-infra-staging-cluster \
  --services aws-advance-infra-staging-service

# Check task definition
aws ecs describe-task-definition \
  --task-definition aws-advance-infra-staging-task-definition

# Check IAM roles
aws iam get-role --role-name aws-advance-infra-staging-ecs-task-role
```

#### **3. Load Balancer Health Check Failures**

```bash
# Check target group health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# Check security groups
aws ec2 describe-security-groups \
  --group-ids $(terraform output -raw load_balancer_security_group_id)

# Verify port configuration
aws elbv2 describe-target-groups \
  --target-group-arns $(terraform output -raw target_group_arn)
```

#### **4. ECR Image Pull Issues**

```bash
# Check ECR repository
aws ecr describe-repositories \
  --repository-names aws-advance-infra-staging-frontend

# Check image tags
aws ecr describe-images \
  --repository-name aws-advance-infra-staging-frontend

# Verify ECS task role permissions
aws iam get-role-policy \
  --role-name aws-advance-infra-staging-ecs-task-role \
  --policy-name ECRAccessPolicy
```

### **Debug Commands**

#### **Terraform Debugging**

```bash
# Enable debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Validate configuration
terraform validate

# Check plan details
terraform plan -out=tfplan
terraform show tfplan
```

#### **AWS Resource Debugging**

```bash
# Check all resources with tags
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Environment,Values=staging

# Check CloudFormation events (if applicable)
aws cloudformation describe-stack-events \
  --stack-name aws-advance-infra-staging
```

## 🔄 Update & Maintenance

### **Infrastructure Updates**

#### **1. Plan Changes**

```bash
cd environments/staging
terraform plan
```

#### **2. Apply Changes**

```bash
terraform apply
```

#### **3. Verify Changes**

```bash
# Check specific resources
terraform output
terraform show
```

### **Application Updates**

#### **1. Push New Images**

```bash
# Build and push new image
docker build -t your-app:latest .
docker tag your-app:latest 123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend:latest
docker push 123456789012.dkr.ecr.us-east-2.amazonaws.com/aws-advance-infra-staging-frontend:latest
```

#### **2. Force ECS Update**

```bash
aws ecs update-service \
  --cluster aws-advance-infra-staging-cluster \
  --service aws-advance-infra-staging-service \
  --force-new-deployment
```

## 🗑️ Cleanup & Destruction

### **Destroy Environment**

```bash
# ⚠️ WARNING: This will destroy all resources!

cd environments/staging
terraform destroy

# Confirm destruction by typing 'yes'
```

### **Destroy Backend**

```bash
# ⚠️ WARNING: This will destroy state management!

cd backend
terraform destroy

# Note: This should be done last, after all environments are destroyed
```

### **Manual Cleanup**

```bash
# Remove ECR images
aws ecr batch-delete-image \
  --repository-name aws-advance-infra-staging-frontend \
  --image-ids imageTag=latest

# Remove S3 objects
aws s3 rm s3://aws-advance-infra-terraform-state-123456789012/staging/ --recursive
```

## 📚 Additional Resources

### **Documentation**

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)

### **Best Practices**

- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/)

### **Support**

- [Terraform Community](https://discuss.hashicorp.com/)
- [AWS Support](https://aws.amazon.com/support/)
- [GitHub Issues](https://github.com/your-repo/issues)

---

## 🎯 Next Steps

After successful deployment:

1. **Monitor Resources**: Set up CloudWatch alarms and monitoring
2. **Security Review**: Conduct security assessment and penetration testing
3. **Performance Testing**: Load test your application
4. **Backup Strategy**: Implement automated backup and recovery procedures
5. **Documentation**: Update runbooks and operational procedures

**Happy Deploying! 🚀**
