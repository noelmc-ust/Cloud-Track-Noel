# VMSS Autoscaling Infrastructure

Terraform implementation of an Azure Virtual Machine Scale Set (VMSS) configured with dynamic autoscaling policies. Built to automatically respond to traffic load and alert administrators on scaling events.

## Infrastructure Components
- **Network**: Virtual Network (VNet) with dual subnets and an integrated NAT Gateway for outbound traffic.
- **Compute**: Azure Virtual Machine Scale Set running Linux instances. 
- **Autoscaling Logic**: 
  - Dynamic scaling rules governing instance counts (Minimum 1, Maximum 3).
  - Condition-based scale-out and scale-in rules based on resource utilization.
- **Monitoring & Alerting**: Configured alerts to send email notifications to administrators when scaling operations occur.

## Environment Management
- **Workspaces**: Uses root modules isolated in environment directories (e.g., `env/dev/`).
- **Modularity**: Implements modular architecture separated into `network` and `compute` layers.

## Repository Structure
```text
VMSS -autoscaling/
├── env/                         # Environments
│   └── dev/                     # Development environment configurations
│       ├── main.tf              # Dev Env Execution File
│       ├── variables.tf         # Dev environment Variables
│       └── output.tf            # Dev outputs
└── modules/                     # Terraform Modules
    ├── compute/                 # VM Scale Set and Autoscaling profile
    └── network/                 # VNet, Subnets, NAT Gateway logic
```

## Traffic Flow & Routing
- **Scaling Behavior**: Instances are automatically provisioned or deprovisioned across the defined subnets based on the autoscaling profile criteria.
- **Egress**: Scale set instances utilize the associated NAT Gateway for all outbound connectivity, ensuring consistent external IP representation.

## Deployment Guide

### Prerequisites
- Azure CLI
- Terraform (>= 1.0.0)
- Azure Subscription

### 1. Configure Target Environment
Update variables in your target environment folder (e.g., `env/dev/variables.tf` or provide a `.tfvars` file) as needed.

### 2. Authenticate
```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 3. Deploy
```bash
cd env/dev
terraform init
terraform plan
terraform apply -auto-approve
```
