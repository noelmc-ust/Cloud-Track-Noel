terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


module "networking" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_cidr           = var.vnet_cidr
}

module "compute" {
  source              = "../../modules/compute"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_subnet_id       = module.networking.app_subnet_id
  nsg_id              = module.networking.nsg_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}


module "app_gateway" {
  source                   = "../../modules/gateway"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  appgw_subnet_id          = module.networking.appgw_subnet_id
  fitness_vm_private_ip    = module.compute.fitness_vm_private_ip
  ghee_vm_private_ip       = module.compute.ghee_vm_private_ip
  pfx_certificate_path     = var.pfx_certificate_path
  pfx_certificate_password = var.pfx_certificate_password
}