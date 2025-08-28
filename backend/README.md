# Backend Infrastructure

This directory contains the global backend infrastructure for Terraform state management.

## 🎯 Purpose

The backend infrastructure provides:

- **S3 Bucket**: For storing Terraform state files
- **DynamoDB Table**: For state locking to prevent concurrent modifications

## 🏗️ Components

- `s3/` - S3 backend configuration
- `dynamodb/` - DynamoDB backend configuration
- `main.tf` - Main backend orchestration
- `variables.tf` - Backend variables
- `outputs.tf` - Backend outputs
- `versions.tf` - Provider and version constraints

## 🚀 Deployment Order

This infrastructure should be deployed **FIRST** before any other environments.
