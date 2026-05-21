# FlowForge Enterprise Infrastructure Routing Platform

An enterprise-grade, highly secure, and automated multi-environment infrastructure architecture deployed on Microsoft Azure using Terraform. 

This platform orchestrates an advanced cloud topology featuring private isolated subnets, zero-direct-internet compute mapping via NAT Gateways, bastion access governance, and domain-based SSL termination using an **Azure Application Gateway (v2)**.

---

## 🗺️ System Architecture

The following diagram illustrates the complete logical and physical layout of the network components, security boundaries, and directional traffic flows for this architecture:

![System Architecture](./Architecture.png)

---

## 🎯 Strategic Objectives: What We Are Achieving

This project transitions standard standalone monolithic application workloads into a highly structured, hardened, production-ready environment that satisfies enterprise compliance frameworks. 

We are systematically achieving four key goals:

1. **Absolute Network Isolation:** No application workload has a direct public IP address or exposure to the open internet. Compute engines live within completely enclosed private subnets (`AppSubnet`).
2. **Centralized Edge Security & Encryption (SSL Termination):** Secure public traffic (`HTTPS` on port 443) terminates explicitly at the Azure Application Gateway layer using Let's Encrypt multi-domain certificates. The internal backbone routes clean traffic directly to targeted internal backend VMs on port 80, offloading cryptographic overhead from individual application layers.
3. **Domain-Based Multi-Site Routing:** Using a single edge gateway interface, traffic is dynamically split via host headers, mapping `flowforge.fun` cleanly to the **Fitness Tracker Web App** and `ghee.flowforge.fun` smoothly to the **Organic Ghee E-Commerce Store**.
4. **Hardened Governance & Access Control:** Administrative infrastructure pathways (`SSH` on port 22) are entirely locked out from public space, routing strictly through an **Azure Bastion Host** proxy lane. All outbound machine channels for system package updates utilize dedicated **NAT Gateways** to hide backend asset origins.

---

## ⚖️ Architectural Decision Records: The "Why" and "How"

### 1. Azure Application Gateway (v2) over Load Balancers or Nginx Reverse Proxies
* **Why:** Traditional Layer-4 Network Load Balancers (NLBs) route raw TCP traffic but cannot inspect HTTP/HTTPS application headers. A software-based proxy like standalone Nginx requires manual scaling and high-availability configuration overhead.
* **How:** We chose the managed **Application Gateway v2 Standard SKU**. This layer-7 application router natively supports **Multi-Site host-header routing**, allows us to bind our multi-domain `.pfx` certificate right to custom edge listeners, and auto-scales dynamically to adjust to traffic surges.

### 2. Private AppSubnets with NAT Gateways
* **Why:** Attaching public IPs directly to app VMs opens major vector attack surfaces to automated brute-force scanning bots. However, running VMs strictly in isolated spaces prevents them from fetching critical system updates (`apt-get update`) or pulling application dependencies via Nginx configuration setups.
* **How:** We attached a dedicated **Azure NAT Gateway** directly to the `AppSubnet`. This enforces that any outward transmission leaving the subnets travels through a single static public IP, while completely blocking any unsolicited inbound connection attempts from hitting our app engines.

### 3. Azure Bastion vs. Public Jump-boxes
* **Why:** Exposing port 22 on any public network card fills system logs with unauthorized login attempts within seconds. 
* **How:** We provisioned an explicit `AzureBastionSubnet` containing a managed **Azure Bastion Host**. This provides secure, TLS-encrypted SSH access directly within the Azure Portal browser interface, avoiding the need to expose any VM ports to the open internet.

---

## 📁 Repository Layout and Directory Structure

```text
App-Gateway/
├── Architecture.png             # Master visual architectural diagram
├── README.md                    # Core documentation playbook (This File)
├── env/                         # Root Execution Environments
│   ├── dev/
│   │   ├── main.tf              # Dev configuration root (calls ../../modules)
│   │   ├── variables.tf         # Dev environment explicit variables
│   │   ├── terraform.tfvars     # Secrets, local certificate path, passwords
│   │   ├── output.tf            # Target public IP output descriptors
│   │   └── flowforge-ssl.pfx    # Local Dev environment SSL Certificate bundle
│   └── prod/
│       ├── main.tf              # Prod configuration root
│       ├── variables.tf         # Prod environment explicit variables
│       ├── output.tf            # Target production public IP outputs
│       └── terraform.tfvars     # Production infrastructure properties
├── modules/                     # Immutable Shared Infrastructure Modules
│   ├── compute/
│   │   ├── main.tf              # Deploys private VMs and bootstraps web servers
│   │   ├── variables.tf         # Compute module contract inputs
│   │   └── output.tf            # Exports private IP allocations
│   ├── gateway/
│   │   ├── main.tf              # Application Gateway layer-7 multi-site logic
│   │   └── variables.tf         # Gateway inputs & SSL variables
│   └── network/
│       ├── main.tf              # Sets up VNet, 3 distinct subnets, NSGs, NAT Gateway, Bastion
│       ├── variables.tf         # Network module variable definitions
│       └── output.tf            # Exports subnet IDs and security group mappings
└── scripts/                     # Dynamic Virtual Machine Bootstrap Scripts
    ├── fitness_bootstrap.sh     # Manual backup installation routines for Fitness App
    └── ghee_bootstrap.sh        # Manual backup installation routines for Ghee App