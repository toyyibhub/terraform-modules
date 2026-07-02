# Terraform AWS Multi-Environment Infrastructure Platform

A production-style Infrastructure as Code (IaC) project built with Terraform on AWS. Implements a modular, scalable, environment-driven architecture using real-world DevOps practices.

---

## Overview

This project provisions and manages AWS infrastructure using reusable Terraform modules across multiple environments. Remote state is stored in S3 with DynamoDB-backed locking, ensuring safe, collaborative deployments. Ansible handles post-provisioning configuration, deploying a simple HTML web server on the provisioned EC2 instances.

**Environments:** `dev` · `qa`

---

## Architecture

Infrastructure is designed around a modular Terraform pattern — each AWS resource type lives in its own reusable module, and each environment composes those modules independently.

### Provisioned Resources

| Resource | Description |
|---|---|
| EC2 | Ubuntu instances, sized per environment |
| IAM Users | Scoped per environment |
| Security Groups | Dynamic inbound/outbound rules |
| S3 Buckets | Environment-specific object storage |

### Design Principles

- Infrastructure as Code (IaC) — all resources are version-controlled
- Reusability via Terraform modules
- Environment isolation — dev and qa are fully independent state trees
- Secure remote state with encryption and locking

---

## Project Structure

```
.
├── backend/                  # Remote state backend provisioning
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── backend.tf
│
├── envs/
│   ├── dev/                  # Development environment
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── backend.tf
│   │
│   └── qa/                   # QA environment
│       ├── main.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── backend.tf
│
├── modules/
│   ├── ec2/
│   ├── iam/
│   ├── s3/
│   └── security_group/
│
├── ansible-playbook/         # Post-provisioning configuration
│   ├── webserver.yml         # Playbook — installs and configures Apache/Nginx
│   ├── ansible.cfg           # Ansible runtime configuration
│   └── inv.ini               # Inventory file — EC2 hosts per environment
│
└── .terraform.lock.hcl
```

---

## Remote State Management

State is managed remotely using AWS-native services:

```
s3://terraform-state-demo/
├── dev/terraform.tfstate
└── qa/terraform.tfstate
```

| Component | Purpose |
|---|---|
| S3 Bucket | Stores Terraform state files |
| DynamoDB Table | Provides state locking to prevent concurrent writes |
| AES-256 Encryption | Enabled on the S3 bucket at rest |

---

## Prerequisites

Ensure the following are installed and configured before deploying:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) >= 2.14
- AWS credentials configured locally

Verify your credentials:

```bash
aws sts get-caller-identity --profile toyyib
```

---

## Deployment

All commands are run from within the target environment directory.

**1. Navigate to the environment**

```bash
cd envs/dev
```

**2. Initialise Terraform**

```bash
terraform init
```

**3. Validate configuration**

```bash
terraform validate
```

**4. Preview the plan**

```bash
terraform plan
```

**5. Apply infrastructure**

```bash
terraform apply
```

Repeat from step 1 using `envs/qa` to deploy the QA environment.

---

## Ansible — Web Server Configuration

Once Terraform has provisioned the EC2 instances, Ansible handles post-provisioning configuration — installing and serving a simple HTML page via a web server.

### Ansible Directory

| File | Purpose |
|---|---|
| `webserver.yml` | Playbook that installs and configures the web server and deploys the HTML page |
| `ansible.cfg` | Ansible runtime settings (remote user, key path, host key checking) |
| `inv.ini` | Inventory file listing EC2 public IPs per environment |

### Running the Playbook

**1. Update the inventory** with your EC2 public IPs after `terraform apply`:

```ini
# ansible-playbook/inv.ini
[webservers]
<ec2-public-ip>
```

**2. Run the playbook**

```bash
cd ansible-playbook
ansible-playbook -i inv.ini webserver.yml
```

**3. Verify**

```bash
curl http://<ec2-public-ip>
```

The playbook installs a web server (Apache/Nginx), deploys a basic HTML page, and ensures the service is enabled on boot.

---

## Environments

### Dev

- Lightweight, cost-optimised instances (`t2.micro`)
- Used for active development and early testing

### QA

- Mirrors a production-like configuration
- Used for integration and validation testing prior to release

---

## Modules

### `ec2`
Provisions Ubuntu EC2 instances. Instance type and AMI are configurable per environment via input variables.

### `iam`
Creates IAM users scoped to the target environment, following least-privilege principles.

### `security_group`
Manages inbound and outbound traffic rules dynamically. Rules are passed in as variables, keeping the module reusable across environments.

### `s3`
Creates environment-specific S3 buckets with consistent naming conventions and configurable access controls.

---

## Security

- State files stored in an AES-256 encrypted S3 bucket
- DynamoDB state locking prevents concurrent `apply` conflicts
- IAM users are scoped per environment with minimal permissions
- No secrets or credentials are hardcoded in any `.tf` file
- AWS credentials are managed via CLI named profiles

---

## Roadmap

- [ ] CI/CD pipeline integration (GitHub Actions or Jenkins)
- [x] Ansible playbooks for post-provisioning EC2 configuration
- [ ] Production environment (`prod`)
- [ ] VPC module for full network isolation
- [ ] CloudWatch / Datadog monitoring integration

---

## Author

Built as a portfolio project demonstrating real-world Terraform patterns for multi-environment AWS infrastructure.
