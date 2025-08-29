# Security Module

This module creates comprehensive security infrastructure including IAM roles, policies, KMS encryption, and security groups.

## 🎯 Purpose

The security module provides:

- **IAM Management**: Roles, policies, and user management
- **KMS Encryption**: Encryption keys for data protection
- **Security Groups**: Network-level security rules
- **Secrets Management**: Secure storage of sensitive data
- **Compliance**: Built-in security best practices

## 🏗️ Architecture

```
Security Module
├── IAM Roles & Policies
│   ├── VPC Flow Log Role
│   ├── Application Roles
│   ├── Admin Roles
│   └── Service Roles
├── KMS Encryption
│   ├── Data Encryption Keys
│   ├── RDS Encryption Keys
│   └── S3 Encryption Keys
├── Security Groups
│   ├── Application Security Groups
│   ├── Database Security Groups
│   └── Load Balancer Security Groups
└── Secrets Manager
    ├── Database Credentials
    ├── API Keys
    └── Application Secrets
```

## 📦 Resources Created

### IAM Security

- **IAM Roles**: For applications, services, and administrative access
- **IAM Policies**: Least privilege access policies
- **IAM Users**: For human access (optional)
- **IAM Groups**: For organizing users and permissions

### Encryption & Keys

- **KMS Keys**: Customer managed encryption keys
- **Key Policies**: Secure key access policies
- **Key Aliases**: Human-readable key names
- **Key Rotation**: Automated key rotation

### Network Security

- **Security Groups**: Stateful firewall rules
- **Network ACLs**: Stateless network filtering
- **VPC Endpoints**: Private AWS service access

### Secrets Management

- **Secrets Manager**: Secure secret storage
- **RDS Secrets**: Database credentials
- **Application Secrets**: API keys and tokens

## 🚀 Usage

### Basic Usage

```hcl
module "security" {
  source = "../../modules/security"

  environment    = "staging"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "security" {
  source = "../../modules/security"

  environment    = "production"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id

  # IAM Configuration
  create_admin_role = true
  create_app_role   = true

  # KMS Configuration
  enable_kms_encryption = true
  key_rotation_enabled  = true

  # Security Groups
  allowed_cidr_blocks = ["10.0.0.0/16", "192.168.1.0/24"]

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
- `vpc_id`: ID of the VPC for security groups

### Optional Variables

- `create_admin_role`: Whether to create admin IAM role
- `create_app_role`: Whether to create application IAM role
- `enable_kms_encryption`: Whether to create KMS encryption keys
- `key_rotation_enabled`: Whether to enable KMS key rotation
- `allowed_cidr_blocks`: CIDR blocks allowed in security groups

## 📤 Outputs

- `vpc_flow_log_role_arn`: ARN of the VPC Flow Log IAM role
- `app_role_arn`: ARN of the application IAM role
- `admin_role_arn`: ARN of the admin IAM role
- `kms_key_arn`: ARN of the KMS encryption key
- `security_group_ids`: List of security group IDs

## 🔒 Security Features

- **Least Privilege**: IAM policies follow principle of least privilege
- **Encryption**: All sensitive data encrypted at rest and in transit
- **Audit Logging**: Comprehensive IAM and CloudTrail logging
- **Key Rotation**: Automated KMS key rotation
- **Secret Rotation**: Automated secret rotation

## 💰 Cost Optimization

- **IAM Roles**: No additional cost for IAM resources
- **KMS Keys**: Pay per API call, not per key
- **Security Groups**: No additional cost
- **Secrets Manager**: Pay per secret per month

## 🧪 Testing

### Test Scenarios

1. **IAM Access**: Verify roles have correct permissions
2. **Security Groups**: Test network access rules
3. **Encryption**: Verify data encryption works
4. **Compliance**: Check security policy compliance

### Validation Rules

- IAM policies must follow least privilege
- Security groups must be restrictive by default
- KMS keys must have proper access policies
- Secrets must be encrypted

## 📚 Dependencies

- AWS Provider
- VPC ID from networking module
- Appropriate AWS permissions for IAM, KMS, and EC2 services

## 🔄 Updates and Maintenance

- **IAM Updates**: Roles and policies can be updated independently
- **Security Groups**: Rules can be modified without affecting other resources
- **KMS Keys**: Key policies can be updated for access control
- **Monitoring**: CloudTrail provides audit trail for all changes
