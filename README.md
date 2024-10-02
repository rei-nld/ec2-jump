# ec2-jump

## Purpose

Terraform deployment for a single EC2 instance.

The deployed EC2 instance should only be used as a jump host for development purposes.

## Content

ec2_instance :
- SSM Agent
- Terraform
- Docker

basic_vpc :
- 1 AZ

ssm_role :
- AdministratorAccess
- AmazonSSMManagedInstanceCore

## Deployment

```bash
git clone
cd ec2-jump
terraform init
terraform apply
```
