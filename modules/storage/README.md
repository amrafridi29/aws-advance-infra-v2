# Storage Module

This module creates comprehensive storage infrastructure including S3 buckets, EBS volumes, RDS databases, and ElastiCache clusters.

## 🎯 Purpose

The storage module provides:

- **S3 Storage**: Application data, backups, logs, and static assets
- **EBS Volumes**: Block storage for EC2 instances
- **RDS Databases**: Managed relational databases
- **ElastiCache**: In-memory caching solutions
- **Storage Lifecycle**: Automated data management and cleanup
- **Data Protection**: Encryption, versioning, and backup policies

## 🏗️ Architecture

```
Storage Module
├── S3 Infrastructure
│   ├── Application Buckets
│   ├── Backup Buckets
│   ├── Log Storage Buckets
│   └── Static Asset Buckets
├── EBS Infrastructure
│   ├── Application Volumes
│   ├── Database Volumes
│   └── Backup Volumes
├── RDS Infrastructure
│   ├── Primary Databases
│   ├── Read Replicas
│   └── Multi-AZ Deployments
├── ElastiCache Infrastructure
│   ├── Redis Clusters
│   ├── Memcached Clusters
│   └── Cache Subnet Groups
└── Storage Lifecycle
    ├── S3 Lifecycle Policies
    ├── EBS Snapshot Policies
    └── RDS Backup Policies
```

## 📦 Resources Created

### S3 Storage

- **Application Bucket**: For application data and uploads
- **Backup Bucket**: For system and database backups
- **Log Bucket**: For application and system logs
- **Static Assets Bucket**: For web assets (CDN-ready)

### EBS Volumes

- **Application Volumes**: For application data storage
- **Database Volumes**: For database storage
- **Backup Volumes**: For temporary backup storage

### RDS Databases

- **Primary Database**: Main application database
- **Read Replicas**: For read-heavy workloads
- **Multi-AZ**: High availability configuration

### ElastiCache

- **Redis Cluster**: For session storage and caching
- **Memcached Cluster**: For object caching
- **Cache Subnet Groups**: Network isolation

## 🚀 Usage

### Basic Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  environment    = "staging"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.private_subnet_ids

  # S3 Storage
  enable_s3_storage = true

  # RDS Database
  enable_rds = true

  # ElastiCache
  enable_elasticache = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  environment    = "production"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.private_subnet_ids

  # S3 Storage with lifecycle
  enable_s3_storage = true
  s3_lifecycle_enabled = true
  s3_versioning_enabled = true

  # RDS with Multi-AZ
  enable_rds = true
  rds_multi_az = true
  rds_backup_retention = 30

  # ElastiCache with Redis
  enable_elasticache = true
  elasticache_engine = "redis"
  elasticache_cluster_size = 3

  # Encryption
  kms_key_arn = module.encryption.main_key_arn

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
- `subnet_ids`: List of subnet IDs for RDS and ElastiCache

### Optional Variables

- `enable_s3_storage`: Whether to create S3 storage infrastructure
- `enable_rds`: Whether to create RDS database infrastructure
- `enable_elasticache`: Whether to create ElastiCache infrastructure
- `enable_ebs`: Whether to create EBS volume infrastructure
- `kms_key_arn`: ARN of the KMS key for encryption
- `s3_lifecycle_enabled`: Whether to enable S3 lifecycle policies
- `rds_multi_az`: Whether to enable RDS Multi-AZ deployment
- `elasticache_engine`: ElastiCache engine (redis or memcached)

## 📤 Outputs

- `s3_bucket_names`: List of S3 bucket names
- `rds_endpoint`: RDS database endpoint
- `elasticache_endpoint`: ElastiCache endpoint
- `ebs_volume_ids`: List of EBS volume IDs
- `storage_summary`: Summary of storage infrastructure

## 🔒 Security Features

- **Encryption**: All data encrypted at rest and in transit
- **Access Control**: IAM-based access to storage resources
- **Network Security**: Resources deployed in private subnets
- **Backup Protection**: Automated backup and recovery
- **Compliance**: Built-in compliance features for various standards

## 💰 Cost Optimization

- **Lifecycle Policies**: Automated data tiering and cleanup
- **Storage Classes**: Appropriate storage classes for different data types
- **Backup Retention**: Configurable backup retention periods
- **Resource Tagging**: Proper tagging for cost allocation

## 🧪 Testing

### Test Scenarios

1. **Data Storage**: Verify data can be stored and retrieved
2. **Encryption**: Verify data is properly encrypted
3. **Backup/Restore**: Test backup and recovery procedures
4. **Performance**: Test storage performance and caching

### Validation Rules

- All data must be encrypted
- Backups must be automated and tested
- Lifecycle policies must be appropriate for data type
- Network access must be properly restricted

## 📚 Dependencies

- AWS Provider
- VPC ID from networking module
- Subnet IDs from networking module
- KMS key ARN from encryption module
- Security group IDs from security module

## 🔄 Updates and Maintenance

- **Storage Expansion**: Can be expanded without affecting other resources
- **Lifecycle Updates**: Policies can be modified for changing requirements
- **Backup Management**: Retention and scheduling can be adjusted
- **Performance Tuning**: Can be optimized based on usage patterns
