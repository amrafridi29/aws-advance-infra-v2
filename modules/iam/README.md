# IAM Module

This module creates comprehensive Identity and Access Management (IAM) infrastructure including roles, policies, users, and groups.

## 🎯 Purpose

The IAM module provides:

- **IAM Roles**: For applications, services, and administrative access
- **IAM Policies**: Custom policies for fine-grained permissions
- **IAM Users**: Human users with appropriate access levels
- **IAM Groups**: User organization and permission management
- **Service Accounts**: Service-specific IAM roles
- **Cross-Account Access**: Trust relationships between accounts

## 🏗️ Architecture

```
IAM Module
├── IAM Roles
│   ├── Application Roles
│   ├── Service Roles
│   ├── Administrative Roles
│   └── Cross-Account Roles
├── IAM Policies
│   ├── Custom Policies
│   ├── Managed Policies
│   └── Inline Policies
├── IAM Users
│   ├── Developers
│   ├── DevOps Engineers
│   └── Administrators
└── IAM Groups
    ├── Development Team
    ├── Operations Team
    └── Security Team
```

## 📦 Resources Created

### IAM Roles

- **Application Role**: For EC2 instances and applications
- **VPC Flow Log Role**: For VPC Flow Logs (used by monitoring module)
- **Admin Role**: For administrative access (optional)
- **Service Role**: For AWS services integration

### IAM Policies

- **Application Policy**: S3, KMS, and basic AWS access
- **VPC Flow Log Policy**: CloudWatch Logs permissions
- **Admin Policy**: Full administrative access (optional)
- **Custom Policies**: Based on specific requirements

### IAM Users and Groups

- **Development Team**: Application developers
- **Operations Team**: DevOps and infrastructure engineers
- **Security Team**: Security administrators

## 🚀 Usage

### Basic Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  environment    = "staging"
  project_name   = "my-project"

  # IAM Roles
  create_app_role = true
  create_admin_role = false

  # VPC Flow Log Role (required for monitoring)
  create_vpc_flow_log_role = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  environment    = "production"
  project_name   = "my-project"

  # IAM Roles
  create_app_role = true
  create_admin_role = true
  create_service_role = true

  # VPC Flow Log Role
  create_vpc_flow_log_role = true

  # Custom Policies
  custom_policies = {
    "database-access" = {
      description = "Database access policy"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "rds:DescribeDBInstances",
              "rds:DescribeDBClusters"
            ]
            Resource = "*"
          }
        ]
      })
    }
  }

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

### Optional Variables

- `create_app_role`: Whether to create application IAM role
- `create_admin_role`: Whether to create admin IAM role
- `create_service_role`: Whether to create service IAM role
- `create_vpc_flow_log_role`: Whether to create VPC Flow Log IAM role
- `custom_policies`: Map of custom IAM policies to create
- `enable_cross_account_access`: Whether to enable cross-account access
- `trusted_account_ids`: List of trusted AWS account IDs

## 📤 Outputs

- `app_role_arn`: ARN of the application IAM role
- `admin_role_arn`: ARN of the admin IAM role
- `vpc_flow_log_role_arn`: ARN of the VPC Flow Log IAM role
- `service_role_arn`: ARN of the service IAM role
- `all_role_arns`: List of all IAM role ARNs
- `custom_policy_arns`: List of custom policy ARNs

## 🔒 Security Features

- **Least Privilege**: Minimal required permissions for each role
- **Conditional Access**: IP-based and time-based access controls
- **Cross-Account Security**: Secure trust relationships
- **Audit Logging**: Complete access logging and monitoring
- **Compliance**: Built-in compliance features for various standards

## 💰 Cost Optimization

- **Role Reuse**: Shared roles across similar services
- **Policy Consolidation**: Efficient permission management
- **Access Reviews**: Regular permission audits and cleanup
- **Automation**: Automated role provisioning and deprovisioning

## 🧪 Testing

### Test Scenarios

1. **Role Assumption**: Verify roles can be assumed correctly
2. **Permission Testing**: Test specific permissions for each role
3. **Cross-Account Access**: Verify trust relationships work
4. **Policy Validation**: Ensure policies grant correct permissions

### Validation Rules

- Roles must have minimal required permissions
- Trust relationships must be secure
- Policies must follow least privilege principle
- Access must be properly logged and monitored

## 📚 Dependencies

- AWS Provider
- Appropriate AWS permissions for IAM management
- VPC ID (if creating VPC Flow Log role)

## 🔄 Updates and Maintenance

- **Role Updates**: Can be modified without affecting other resources
- **Policy Changes**: Can be updated for changing requirements
- **User Management**: Easy to add/remove users and groups
- **Access Reviews**: Regular audits and permission updates
