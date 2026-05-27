# Basic Terraform Infrastructure Setup

Implementation of a foundational Azure infrastructure using Terraform. This setup provisions a basic web and application tier without load balancers, using a single virtual network.

## Infrastructure Components
- **Network**: Resource Group, Virtual Network (VNet), Web Subnet, and App Subnet.
- **Compute**: 2 Linux Virtual Machines (`web-vm` and `app-vm`).
- **Outbound Connectivity**: Azure NAT Gateway associated with both Web and App subnets for secure outbound internet access.
- **Security**: 
  - Web Network Security Group (NSG) allowing inbound SSH, HTTP, and HTTPS.
  - App Network Security Group (NSG) allowing SSH access from the internal 10.0.1.0/24 network.

## Repository Structure
```text
Basic Terraform Setup/
├── main.tf              # Main infrastructure declarations
├── variables.tf         # Variable definitions
├── output.tf            # Output values
└── providers.tf         # Terraform provider configurations
```

## Traffic Flow & Routing
- **Ingress**: Traffic is permitted directly to the Web VM via Public IP or allowed ports defined in the NSG.
- **Egress**: All outbound internet traffic from the subnets is routed through the NAT Gateway.

## Deployment Guide

### Prerequisites
- Azure CLI
- Terraform (~> 3.0)
- Azure Subscription

### 1. Authenticate
```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 2. Deploy
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### 3. Teardown
To remove the infrastructure:
```bash
terraform destroy -auto-approve
```
