  provider "azurerm" {
    features {}
  }

  resource "azurerm_resource_group" "rs1" {
    name     = "app_centralindia"
    location = var.rs_location
  }

  resource "azurerm_virtual_network" "vnet-app" {
    name                = "vnet-app"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location
    address_space       = var.vnet-addr
  }

  resource "azurerm_subnet" "pubsub" {
    name                 = "public-subnet"
    address_prefixes     = var.pubsubadd
    resource_group_name  = azurerm_resource_group.rs1.name
    virtual_network_name = azurerm_virtual_network.vnet-app.name
  }

  resource "azurerm_subnet" "privsub" {
    name                 = "private-subnet"
    address_prefixes     = var.privsubadd
    resource_group_name  = azurerm_resource_group.rs1.name
    virtual_network_name = azurerm_virtual_network.vnet-app.name
  }

  resource "azurerm_nat_gateway" "nat" {
    name                = "private-nat"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location
    sku_name            = "Standard"
  }

  resource "azurerm_public_ip" "nat-ip" {
    name                = "nat-publicip"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location
    sku                 = "Standard"
    allocation_method   = "Static"
  }

  resource "azurerm_nat_gateway_public_ip_association" "natip-assoc" {
    nat_gateway_id       = azurerm_nat_gateway.nat.id
    public_ip_address_id = azurerm_public_ip.nat-ip.id
  }

  resource "azurerm_subnet_nat_gateway_association" "nat-assoc" {
    nat_gateway_id = azurerm_nat_gateway.nat.id
    subnet_id      = azurerm_subnet.privsub.id
  }

  resource "azurerm_public_ip" "pubip" {
    name                = "public-vm-ip-address"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location
    sku                 = "Standard"
    allocation_method   = "Static"
  }


  resource "azurerm_network_interface" "pubnic" {
    name                = "public-nic"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location

    ip_configuration {
      name                          = "public"
      subnet_id                     = azurerm_subnet.pubsub.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = azurerm_public_ip.pubip.id
    }
  }

  resource "azurerm_linux_virtual_machine" "pub-vm" {
    name                            = var.pub-vm-name
    resource_group_name             = azurerm_resource_group.rs1.name
    location                        = var.rs_location
    network_interface_ids           = [azurerm_network_interface.pubnic.id]
    size                            = var.vmsize
    admin_username                  = var.usr
    admin_password                  = var.pwd
    disable_password_authentication = false
    custom_data = base64encode(file("setup.sh"))
    depends_on = [ azurerm_network_interface.pubnic ]

    os_disk {
      caching              = var.caching
      storage_account_type = var.storage-account
    }

    source_image_reference {
      publisher = var.publisher
      offer     = var.offer
      sku       = var.sku
      version   = var.image-version
    }
  }

  resource "azurerm_network_interface" "privnic" {
    name                = "private-nic"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location

    ip_configuration {
      name                          = "private-nic"
      subnet_id                     = azurerm_subnet.privsub.id
      private_ip_address_allocation = "Dynamic"
    }
  }

  resource "azurerm_linux_virtual_machine" "privvm" {
    name                            = var.priv-vm-name
    resource_group_name             = azurerm_resource_group.rs1.name
    location                        = var.rs_location
    network_interface_ids           = [azurerm_network_interface.privnic.id]
    size                            = var.vmsize
    admin_username                  = var.usr
    admin_password                  = var.pwd
    disable_password_authentication = false
    custom_data = base64encode(file("setup.sh"))
    depends_on = [azurerm_subnet_nat_gateway_association.nat-assoc]

    os_disk {
      caching              = var.caching
      storage_account_type = var.storage-account
    }

    source_image_reference {
      publisher = var.publisher
      version   = var.image-version
      offer     = var.offer
      sku       = var.sku
    }
  }

  resource "azurerm_network_security_group" "pub-nsg" {
    name                = "public-nsg"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location

    security_rule {
      name                       = "HTTP"
      priority                   = "110"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.1.0/24"
    }

    security_rule {
      name                       = "SSH"
      priority                   = "100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.1.0/24"
    }

  }

  resource "azurerm_subnet_network_security_group_association" "pub-nsg-assoc" {
    subnet_id                 = azurerm_subnet.pubsub.id
    network_security_group_id = azurerm_network_security_group.pub-nsg.id
  }

  resource "azurerm_network_security_group" "priv-nsg" {
    name                = "private-nsg"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location

    security_rule {
      name                       = "HTTP"
      priority                   = "110"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.2.0/24"
    }

    security_rule {
      name                       = "SSH"
      priority                   = "100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.2.0/24"
    }

  }

  resource "azurerm_subnet_network_security_group_association" "priv-nsg-assoc" {
    subnet_id                 = azurerm_subnet.privsub.id
    network_security_group_id = azurerm_network_security_group.priv-nsg.id
  }

  resource "azurerm_public_ip" "lb-pip" {
    name                = var.lb-name
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location
    sku                 = "Standard"
    allocation_method   = "Static"
  }


  resource "azurerm_lb" "app-lb" {
    name                = "frontend-lb"
    resource_group_name = azurerm_resource_group.rs1.name
    location            = var.rs_location
    sku                 = "Standard"

    frontend_ip_configuration {
      name                 = var.lb-name
      public_ip_address_id = azurerm_public_ip.lb-pip.id
    }
  }

  resource "azurerm_lb_backend_address_pool" "bk-pool" {
    name            = "backend-app-pool"
    loadbalancer_id = azurerm_lb.app-lb.id
  }

  resource "azurerm_network_interface_backend_address_pool_association" "nic-backpool-assoc" {
    ip_configuration_name   = "private-nic"
    network_interface_id    = azurerm_network_interface.privnic.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.bk-pool.id
  }

  resource "azurerm_lb_probe" "health" {
    loadbalancer_id = azurerm_lb.app-lb.id
    name            = "test-probe"
    port            = 80
    protocol        = "Tcp"
  }

  resource "azurerm_lb_rule" "allowapp" {
    name                           = "Allow-app-access"
    loadbalancer_id                = azurerm_lb.app-lb.id
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = var.lb-name
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bk-pool.id]
    probe_id                       = azurerm_lb_probe.health.id
  }





