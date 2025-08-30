# ECR Module

This module creates and manages Amazon Elastic Container Registry (ECR) repositories for your container images.

## Purpose

- **Container Registry**: Store and manage Docker images for frontend and backend applications
- **Image Management**: Automatic cleanup of old images with lifecycle policies
- **Security**: Image scanning and encryption
- **Access Control**: Repository policies for ECS task access

## Architecture

```
ECR Repositories
├── Frontend Repository (React)
│   ├── Image scanning
│   ├── Lifecycle policies
│   └── Repository policies
└── Backend Repository (NestJS)
    ├── Image scanning
    ├── Lifecycle policies
    └── Repository policies
```

## Resources Created

- **ECR Repositories**: Frontend and backend image storage
- **Lifecycle Policies**: Automatic cleanup of old images
- **Repository Policies**: ECS task access permissions
- **Image Scanning**: Security vulnerability detection

## Usage

```terraform
module "ecr" {
  source = "../../modules/ecr"

  environment  = "staging"
  project_name = "my-app"

  # Enable both repositories
  enable_frontend_repository = true
  enable_backend_repository  = true

  # Features
  enable_image_scanning     = true
  enable_lifecycle_policies = true
  max_image_count           = 10

  tags = {
    Environment = "staging"
    Project     = "my-app"
  }
}
```

## Outputs

- `frontend_repository_url`: URL to push/pull frontend images
- `backend_repository_url`: URL to push/pull backend images
- `repository_urls`: Map of all repository URLs
- `ecr_summary`: Summary of ECR infrastructure

## Docker Commands

### Push Images

```bash
# Frontend
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $(terraform output -raw frontend_repository_url)
docker tag frontend:latest $(terraform output -raw frontend_repository_url):latest
docker push $(terraform output -raw frontend_repository_url):latest

# Backend
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $(terraform output -raw backend_repository_url):latest
docker tag backend:latest $(terraform output -raw backend_repository_url):latest
docker push $(terraform output -raw backend_repository_url):latest
```

### Pull Images

```bash
# Frontend
docker pull $(terraform output -raw frontend_repository_url):latest

# Backend
docker pull $(terraform output -raw backend_repository_url):latest
```

## Best Practices

1. **Always use latest tag** for continuous deployment
2. **Enable image scanning** for security
3. **Use lifecycle policies** to manage storage costs
4. **Repository policies** for secure access control
5. **Tag images consistently** for version management

## Dependencies

- AWS Provider
- IAM permissions for ECR operations
- ECS task execution role with ECR permissions
