# Azure Cloud Infrastructure (Terraform)

This repository contains a collection of Microsoft Azure cloud infrastructure projects built and managed using **Terraform** as part of my azure cloud track training. Each project demonstrates a unique architectural pattern or cloud concept, scaling from basic networking to advanced multi-region hub-and-spoke topologies.

## Repository Contents

The projects are separated into their respective folders. Below is a high-level overview of what each folder contains:

### 1. [AppGateway-Domain](./AppGateway-Domain)
**Domain-Based Routing & WAF**
Implements an Azure Application Gateway with Web Application Firewall (WAF) to handle SSL termination and Layer-7 host-based routing (e.g., routing traffic to different backend VM pools based on the requested domain name).

### 2. [Basic Terraform Setup](./Basic%20Terraform%20Setup)
**Foundational Infrastructure**
A starting template for Azure deployments. Provisions a basic virtual network with isolated Web and App subnets, Linux Virtual Machines, NAT Gateway for outbound traffic, and Network Security Groups (NSGs).

### 3. [Cloud-Project-1](./Cloud-Project-1)
**Multi-Region Hub-and-Spoke Architecture**
An enterprise-grade infrastructure utilizing a hub-and-spoke network topology across multiple Azure regions. Features global routing via Traffic Manager, centralized security using Azure Firewall, Virtual Machine Scale Sets (VMSS), and an Azure Cosmos DB backend.

### 4. [Fitness_tracker-Terraform](./Fitness_tracker-Terraform)
**VNet Peering & Decoupled Architecture**
Demonstrates a multi-tier architecture where the web frontend and database backend (MongoDB) are isolated into two completely separate Virtual Networks connected securely via VNet Peering. 

### 5. [Organic-Ghee-Terraform](./Organic-Ghee-Terraform)
**Public & Private Subnets**
A classic single-VNet architecture partitioned into public and private tiers. Uses a public load balancer pointing to private web instances, a public jumpbox/bastion VM for SSH access, and a NAT Gateway to provide secure internet egress for the private tier.

### 6. [VMSS -autoscaling](./VMSS%20-autoscaling)
**Automated Scaling & Alerting**
Focuses on dynamic compute provisioning. Implements an Azure Virtual Machine Scale Set (VMSS) configured with custom autoscale rules based on load and email alerts to administrators upon scaling events.

## Getting Started

Each project folder contains its own detailed `README.md` that includes:
- Architecture Diagrams
- Component descriptions
- Traffic flow
- Specific deployment instructions

### General Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated (`az login`)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- An active Azure Subscription

To deploy any of the projects, navigate to their respective directory (or their `env/dev/` directory for modular setups), initialize Terraform, and apply:

```bash
terraform init
terraform plan
terraform apply
```
