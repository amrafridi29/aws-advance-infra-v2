# Encryption Module

This module creates comprehensive encryption infrastructure using AWS KMS (Key Management Service) for data encryption and key management.

## 🎯 Purpose

The encryption module provides:

- **KMS Encryption Keys**: Customer-managed encryption keys
- **Key Aliases**: Human-readable names for encryption keys
- **Key Rotation**: Automatic key rotation for security
- **Key Policies**: Fine-grained access control to keys
- **Multi-Region Keys**: Cross-region key replication
- **Encryption Context**: Additional security controls

## 🏗️ Architecture

```
Encryption Module
├── KMS Keys
│   ├── Data Encryption Keys
│   ├── Application Keys
│   ├── Database Keys
│   └── Backup Keys
├── Key Aliases
│   ├── Human-readable Names
│   ├── Environment-specific Aliases
│   └── Service-specific Aliases
├── Key Policies
│   ├── Admin Access
│   ├── Application Access
│   └── Service Access
└── Key Rotation
    ├── Automatic Rotation
    ├── Manual Rotation
    └── Rotation Policies
```

## 📦 Resources Created

### KMS Encryption Keys

- **Main Encryption Key**: Primary encryption key for the environment
- **Application Key**: Key for application-specific encryption
- **Database Key**: Key for database encryption
- **Backup Key**: Key for backup encryption

### Key Aliases

- **Main Key Alias**: Primary key alias
- **Service Aliases**: Service-specific key aliases
- **Environment Aliases**: Environment-specific naming

### Key Policies

- **Admin Policy**: Full administrative access
- **Application Policy**: Application encryption/decryption access
- **Service Policy**: AWS service integration access

## 🚀 Usage

### Basic Usage

```hcl
module "encryption" {
  source = "../../modules/encryption"

  environment    = "staging"
  project_name   = "my-project"

  # Basic encryption
  enable_kms_encryption = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "encryption" {
  source = "../../modules/encryption"

  environment    = "production"
  project_name   = "my-project"

  # Multiple encryption keys
  enable_kms_encryption = true
  enable_application_key = true
  enable_database_key = true
  enable_backup_key = true

  # Key rotation
  key_rotation_enabled = true
  rotation_schedule = "P30D"  # Every 30 days

  # Multi-region
  enable_multi_region = true
  replica_regions = ["us-west-2", "eu-west-1"]

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

- `enable_kms_encryption`: Whether to create KMS encryption keys
- `enable_application_key`: Whether to create application-specific key
- `enable_database_key`: Whether to create database encryption key
- `enable_backup_key`: Whether to create backup encryption key
- `key_rotation_enabled`: Whether to enable automatic key rotation
- `rotation_schedule`: Key rotation schedule (ISO 8601 duration)
- `enable_multi_region`: Whether to enable multi-region keys
- `replica_regions`: List of regions for key replication

## 📤 Outputs

- `main_key_arn`: ARN of the main encryption key
- `main_key_id`: ID of the main encryption key
- `main_key_alias`: Alias of the main encryption key
- `application_key_arn`: ARN of the application encryption key
- `database_key_arn`: ARN of the database encryption key
- `backup_key_arn`: ARN of the backup encryption key
- `all_key_arns`: List of all encryption key ARNs

## 🔒 Security Features

- **Customer-Managed Keys**: Full control over encryption keys
- **Key Rotation**: Automatic or manual key rotation
- **Access Control**: Fine-grained IAM policies for key access
- **Audit Logging**: Complete key usage logging
- **Compliance**: Built-in compliance features for various standards
- **Encryption Context**: Additional security controls

## 💰 Cost Optimization

- **Key Reuse**: Shared keys across similar services
- **Efficient Rotation**: Optimized rotation schedules
- **Regional Distribution**: Strategic key placement
- **Access Management**: Proper access controls to prevent misuse

## 🧪 Testing

### Test Scenarios

1. **Key Creation**: Verify keys are created correctly
2. **Encryption/Decryption**: Test key functionality
3. **Key Rotation**: Verify rotation works as expected
4. **Access Control**: Test IAM policies for key access

### Validation Rules

- Keys must have proper access controls
- Rotation must be configured appropriately
- Aliases must be descriptive and consistent
- Policies must follow least privilege principle

## 📚 Dependencies

- AWS Provider
- Appropriate AWS permissions for KMS management
- IAM roles and policies (from IAM module)

## 🔄 Updates and Maintenance

- **Key Updates**: Can be modified without affecting encrypted data
- **Policy Changes**: Can be updated for changing requirements
- **Rotation Management**: Easy to adjust rotation schedules
- **Access Reviews**: Regular audits and permission updates
