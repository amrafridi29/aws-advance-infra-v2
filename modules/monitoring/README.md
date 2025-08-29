# Monitoring Module

This module creates comprehensive monitoring and observability infrastructure including CloudWatch, CloudTrail, VPC Flow Logs, and logging.

## 🎯 Purpose

The monitoring module provides:

- **CloudWatch Monitoring**: Dashboards, alarms, and metrics
- **Logging Infrastructure**: Log groups, log streams, and retention
- **VPC Flow Logs**: Network traffic monitoring and analysis
- **CloudTrail**: API call logging and audit trails
- **Alerting**: SNS notifications and alarm actions
- **Observability**: Complete visibility into infrastructure

## 🏗️ Architecture

```
Monitoring Module
├── CloudWatch Infrastructure
│   ├── Log Groups
│   ├── Dashboards
│   ├── Alarms
│   └── Metrics
├── Logging & Flow Logs
│   ├── VPC Flow Logs
│   ├── Application Logs
│   ├── Security Logs
│   └── System Logs
├── Audit & Compliance
│   ├── CloudTrail
│   ├── Config Rules
│   └── Compliance Reports
└── Alerting & Notifications
    ├── SNS Topics
    ├── Alarm Actions
    └── Escalation Policies
```

## 📦 Resources Created

### CloudWatch Infrastructure

- **Log Groups**: For various application and system logs
- **Dashboards**: Custom monitoring dashboards
- **Alarms**: Metric-based alarms with actions
- **Metrics**: Custom metrics and filters

### Logging & Flow Logs

- **VPC Flow Logs**: Network traffic monitoring
- **Application Logs**: Structured logging for applications
- **Security Logs**: IAM, KMS, and security events
- **System Logs**: Infrastructure and operational logs

### Audit & Compliance

- **CloudTrail**: API call logging and audit
- **Config Rules**: Resource configuration monitoring
- **Compliance**: SOC2, PCI, HIPAA compliance features

### Alerting & Notifications

- **SNS Topics**: Notification delivery
- **Alarm Actions**: Automated responses to alarms
- **Escalation**: Multi-level alerting

## 🚀 Usage

### Basic Usage

```hcl
module "monitoring" {
  source = "../../modules/monitoring"

  environment    = "staging"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id

  # VPC Flow Logs
  enable_vpc_flow_logs = true

  # CloudWatch Logs
  enable_cloudwatch_logs = true

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "monitoring" {
  source = "../../modules/monitoring"

  environment    = "production"
  project_name   = "my-project"
  vpc_id         = module.networking.vpc_id

  # VPC Flow Logs
  enable_vpc_flow_logs = true
  flow_log_retention_days = 90

  # CloudWatch Logs
  enable_cloudwatch_logs = true
  log_retention_days = 365

  # CloudTrail
  enable_cloudtrail = true
  cloudtrail_retention_days = 90
  # Note: CloudTrail requires an existing S3 bucket for log storage

  # Alarms
  enable_alarms = true
  alarm_email = "devops@company.com"

  # Dashboards
  enable_dashboards = true

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
- `vpc_id`: ID of the VPC for VPC Flow Logs

### Optional Variables

- `enable_vpc_flow_logs`: Whether to enable VPC Flow Logs
- `enable_cloudwatch_logs`: Whether to enable CloudWatch logging
- `enable_cloudtrail`: Whether to enable CloudTrail
- `cloudtrail_s3_bucket_name`: Name of the S3 bucket for CloudTrail logs (must exist)
- `enable_alarms`: Whether to create CloudWatch alarms
- `enable_dashboards`: Whether to create monitoring dashboards
- `flow_log_retention_days`: VPC Flow Log retention period
- `log_retention_days`: CloudWatch log retention period
- `alarm_email`: Email for alarm notifications

## 📤 Outputs

- `vpc_flow_log_ids`: List of VPC Flow Log IDs
- `flow_log_group_names`: List of CloudWatch Log Group names
- `cloudtrail_arn`: ARN of the CloudTrail trail
- `sns_topic_arn`: ARN of the SNS notification topic
- `dashboard_names`: List of CloudWatch dashboard names
- `alarm_names`: List of CloudWatch alarm names

## 🔒 Security Features

- **Encrypted Logs**: All logs encrypted at rest and in transit
- **Access Control**: IAM-based access to monitoring resources
- **Audit Trail**: Complete audit logging of all activities
- **Compliance**: Built-in compliance features for various standards

## 💰 Cost Optimization

- **Log Retention**: Configurable retention periods
- **Alarm Actions**: Automated responses to reduce manual intervention
- **Resource Tagging**: Proper tagging for cost allocation
- **Lifecycle Policies**: Automated cleanup of old logs

## 🧪 Testing

### Test Scenarios

1. **Log Generation**: Verify logs are being created
2. **Alarm Triggers**: Test alarm conditions and actions
3. **Flow Logs**: Verify network traffic logging
4. **Dashboard Display**: Check monitoring dashboards

### Validation Rules

- Log retention must be appropriate for compliance
- Alarms must have proper thresholds
- Flow logs must capture all traffic
- Notifications must be delivered correctly

## 📚 Dependencies

- AWS Provider
- VPC ID from networking module
- IAM role ARN from security module
- Appropriate AWS permissions for CloudWatch, CloudTrail, and SNS

## 🔄 Updates and Maintenance

- **Log Retention**: Can be updated without affecting other resources
- **Alarm Thresholds**: Can be modified for changing requirements
- **Dashboard Updates**: Can be enhanced with new metrics
- **Flow Logs**: Can be enabled/disabled as needed
