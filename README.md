<p align="center">
  <b><span style="font-size:1.2em; color:#007acc;">Author: Samar Dash</span></b>
</p>

# Terraform AWS Modular Infrastructure

This project provides a modular, production-ready Terraform setup for deploying AWS infrastructure. It is designed for clarity, reusability, and security, making it easy to manage and extend your cloud resources.

## Features

- **Environment-Based Structure**: Separate configurations for dev and prod environments
- **Modular Architecture**: Reusable modules for network, security, compute, storage, monitoring, DNS, and IAM
- **Multi-Environment Support**: Easy deployment across different environments with environment-specific configurations
- **AWS Best Practices**: Follows AWS Well-Architected Framework principles
- **Scalable Design**: Modular structure allows easy addition of new services and environments

## Folder Structure

```
terraform/
├── environments/          # Environment-specific configurations
│   ├── dev/              # Development environment
│   │   ├── main.tf       # Dev environment main configuration
│   │   ├── variables.tf  # Dev-specific variables
│   │   ├── outputs.tf    # Dev environment outputs
│   │   └── providers.tf  # AWS provider configuration
│   └── prod/             # Production environment
│       ├── main.tf       # Prod environment main configuration
│       ├── variables.tf  # Prod-specific variables
│       ├── outputs.tf    # Prod environment outputs
│       └── providers.tf  # AWS provider configuration
└── modules/              # Reusable Terraform modules
    ├── network/          # VPC, subnets, route tables
    ├── security/         # Security groups and NACLs
    ├── compute/          # EC2, Auto Scaling, Load Balancers
    ├── storage/          # S3, EBS, EFS resources
    ├── monitoring/       # CloudWatch, SNS, alarms
    ├── dns/              # Route53 configurations
    └── iam/              # IAM roles, policies, users
```

## How to Use

1. **Clone the repository**
2. **Navigate to desired environment**
   ```sh
   cd environments/dev  # or environments/prod
   ```
3. **Initialize Terraform**
   ```sh
   terraform init
   ```
4. **Review and customize variables in variables.tf**
5. **Plan the deployment**
   ```sh
   terraform plan
   ```
6. **Apply the configuration**
   ```sh
   terraform apply
   ```

## Project Highlights
- **Environment Isolation**: Separate state files and configurations for dev/prod environments
- **Reusable Modules**: DRY principle with shared modules across environments
- **Security Best Practices**: IAM roles with least-privilege access
- **Scalable Architecture**: Easy to add new environments and services
- **State Management**: Environment-specific Terraform state files

## Requirements
- Terraform >= 1.0.0
- AWS CLI configured with appropriate permissions
- Access to create resources in target AWS account

## Module Usage
Each module in the `modules/` directory can be used independently:

```hcl
module "network" {
  source = "../../modules/network"
  # module-specific variables
}
```

## Adding New Environments
1. Create new directory under `environments/`
2. Copy configuration files from existing environment
3. Customize variables for new environment
4. Initialize and apply Terraform

## License
MIT

---

