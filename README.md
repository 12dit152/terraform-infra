<p align="center">
  <b><span style="font-size:1.2em; color:#007acc;">Author: Samar Dash</span></b>
</p>

# Terraform AWS Modular Infrastructure

This project provides a modular, production-ready Terraform setup for deploying AWS infrastructure. It is designed for clarity, reusability, and security, making it easy to manage and extend your cloud resources.

## Features

- **Modular Structure**: Each major AWS resource (VPC, IAM, Security Groups, CloudWatch) is managed in its own module for easy maintenance and scalability.
- **VPC & Subnets**: Creates a VPC with multiple public and private subnets across availability zones.
- **Security Groups**: Configurable security groups for SSH, HTTP, and HTTPS, with support for custom rules.
- **CloudWatch Logging**: Sets up CloudWatch log groups and VPC Flow Logs for all subnets, with separate log groups for allow/deny traffic.
- **IAM Best Practices**: Uses a dedicated IAM role for VPC Flow Logs with least-privilege permissions.
- **Outputs**: Exposes key resource IDs and ARNs for use in other modules or for reference.

## Folder Structure

```
terraform/
├── main.tf                # Root module, loads all submodules
├── vpc/                   # VPC, subnets, route tables, and flow logs
│   └── main.tf
├── security_groups/       # Security group definitions
│   └── main.tf
├── cloudwatch/            # CloudWatch log group resources
│   └── main.tf
├── iam/                   # IAM roles and policies
│   └── main.tf
```

## How to Use

1. **Clone the repository**
2. **Initialize Terraform**
   ```sh
   terraform init
   ```
3. **Review and customize variables as needed**
4. **Plan the deployment**
   ```sh
   terraform plan
   ```
5. **Apply the configuration**
   ```sh
   terraform apply
   ```

## Project Highlights
- All subnets (public and private) have VPC Flow Logs enabled, with logs sent to CloudWatch using a secure IAM role.
- Security groups are modular and can be easily extended for new services.
- IAM permissions follow the principle of least privilege.
- CloudWatch log groups have configurable retention policies.

## Requirements
- Terraform >= 1.0.0
- AWS CLI credentials with permissions to create IAM, VPC, CloudWatch, and related resources

## Customization
- Edit the respective `main.tf` files in each module to adjust CIDR blocks, subnet counts, security group rules, log retention, etc.
- Add new modules for additional AWS services as needed.

## License
MIT

---

