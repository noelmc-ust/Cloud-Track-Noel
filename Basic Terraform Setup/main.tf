provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = "rg_1"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myvnet"
  address_space       = var.vnetadd
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "web-subnet" {
  name                 = "web-demo-subnet"
  address_prefixes     = var.webadd
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "app-subnet" {
  name                 = "app-demo-subnet"
  address_prefixes     = var.appadd
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# resource "azurerm_subnet" "db-subnet" {
#     name = "db-demo-subnet"
#     address_prefixes = ["10.0.3.0/24"]
#     resource_group_name = azurerm_resource_group.rg1.name
#     virtual_network_name = azurerm_virtual_network.vnet.name
# }

resource "azurerm_nat_gateway" "nat" {
  name                = "nat-gateway"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku_name            = "Standard"
}

resource "azurerm_public_ip" "nat-pip" {
  name                = "nat-publicip"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat-pip-assoc" {
  public_ip_address_id = azurerm_public_ip.nat-pip.id
  nat_gateway_id       = azurerm_nat_gateway.nat.id

}

resource "azurerm_subnet_nat_gateway_association" "nat-assoc" {
  subnet_id      = azurerm_subnet.app-subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "webnat-assoc" {
  subnet_id      = azurerm_subnet.web-subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}


resource "azurerm_network_interface" "web-nic1" {
  name                = "web-nic-1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.web-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

# resource "azurerm_network_interface" "web-nic2" {
#     name = "web-nic-2"
#     resource_group_name = azurerm_resource_group.rg1.name
#     location = azurerm_resource_group.rg1.location

#     ip_configuration {
#         name = "public"
#         subnet_id = azurerm_subnet.web-subnet.id
#         private_ip_address_allocation = "Dynamic"
#     }

# }


resource "azurerm_network_interface" "app-nic1" {
  name                = "app-nic-1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# resource "azurerm_network_interface" "app-nic2" {
#     name = "app-nic-2"
#     resource_group_name = azurerm_resource_group.rg1.name
#     location = azurerm_resource_group.rg1.location

#     ip_configuration {
#         name = "Internal"
#         subnet_id = azurerm_subnet.app-subnet.id
#         private_ip_address_allocation = "Dynamic"
#     }

# }

# resource "azurerm_network_interface" "db-nic" {
#     name = "db-nic"
#     resource_group_name = azurerm_resource_group.rg1.name
#     location = azurerm_resource_group.rg1.location

#     ip_configuration  {
#         name = "Db-Network"
#         subnet_id = azurerm_subnet.db-subnet.id
#         private_ip_address_allocation = "Dynamic"
#     }

# }

resource "azurerm_linux_virtual_machine" "app-vm1" {
  name                            = var.appvm1name
  location                        = azurerm_resource_group.rg1.location
  resource_group_name             = azurerm_resource_group.rg1.name
  network_interface_ids           = [azurerm_network_interface.app-nic1.id]
  size                            = var.appvm1size
  admin_username                  = var.appvmusr
  admin_password                  = var.appvmpwd
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image-publisher
    version   = var.image-version
    offer     = var.image-offer
    sku       = var.image-sku
  }
}

# resource "azurerm_linux_virtual_machine" "app-vm2" {
#     name = "app-vm-2"
#     location = azurerm_resource_group.rg1.location
#     resource_group_name = azurerm_resource_group.rg1.name
#     size = "Standard_B2ats_v2"
#     network_interface_ids = [azurerm_network_interface.app-nic2.id]
#     admin_username = "noelmc9812"
#     admin_password = "Azure@12345"
#     disable_password_authentication = false

#     os_disk{
#         caching = "ReadWrite"
#         storage_account_type = "Standard_LRS"
#     }

#     source_image_reference {
#         publisher = "Canonical"
#         version = "latest"
#         offer = "0001-com-ubuntu-server-jammy"
#         sku = "22_04-lts"
#     }

# }

resource "azurerm_linux_virtual_machine" "web-vm1" {
  name                            = var.webvm1name
  location                        = azurerm_resource_group.rg1.location
  resource_group_name             = azurerm_resource_group.rg1.name
  size                            = var.webvm1size
  network_interface_ids           = [azurerm_network_interface.web-nic1.id]
  admin_username                  = var.webvmusr
  admin_password                  = var.webvmpwd
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image-publisher
    version   = var.image-version
    offer     = var.image-offer
    sku       = var.image-sku
  }
}

# resource "azurerm_linux_virtual_machine" "web-vm2" {
#   name                            = "web-vm-2"
#   location                        = azurerm_resource_group.rg1.location
#   resource_group_name             = azurerm_resource_group.rg1.name
#   size                            = "Standard_B2als_v2"
#   network_interface_ids           = [azurerm_network_interface.web-nic2.id]
#   admin_username                  = "noelmc9812"
#   admin_password                  = "Azure@12345"
#   disable_password_authentication = false

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     version   = "latest"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#   }
# }

# resource "azurerm_linux_virtual_machine" "db-vm" {
#     name = "db-vm"
#     resource_group_name = azurerm_resource_group.rg1.name
#     location = azurerm_resource_group.rg1.location
#     size = "Standard_B2ats_v2"
#     network_interface_ids = [azurerm_network_interface.db-nic.id]
#     admin_username = "noelmc9812"
#     admin_password = "Azure@12345"
#     disable_password_authentication = false

#     os_disk {
#         caching = "ReadWrite"
#         storage_account_type = "Standard_LRS"
#     }

#     source_image_reference {
#         publisher = "Canonical"
#         version = "latest"
#         offer = "0001-com-ubuntu-server-jammy"
#         sku = "22_04-lts"
#     }

# }

resource "azurerm_network_security_group" "web-nsg" {
  name                = "web-nsg"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }

  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 130
    access                     = "Allow"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "web-nsg-assoc" {
  subnet_id                 = azurerm_subnet.web-subnet.id
  network_security_group_id = azurerm_network_security_group.web-nsg.id
}

resource "azurerm_network_security_group" "app-nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "app-nsg-assoc" {
  subnet_id                 = azurerm_subnet.app-subnet.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}

# resource "azurerm_network_security_group" "db-nsg" {
#     name = "db-nsg"
#     resource_group_name = azurerm_resource_group.rg1.name
#     location = azurerm_resource_group.rg1.location

#     security_rule {
#         name = "DbOnly"
#         priority = 100
#         direction = "Inbound"
#         access = "Allow"
#         protocol = "Tcp"
#         source_port_range = "*"
#         destination_port_range = "5432"
#         source_address_prefix = "10.0.2.0/24"
#         destination_address_prefix = "*"
#     }

#     security_rule {
#         name = "DefaultDeny"
#         priority = 110
#         direction = "Outbound"
#         access = "Deny"
#         protocol = "*"
#         source_port_range = "*"
#         destination_port_range = "*"
#         source_address_prefix = "*"
#         destination_address_prefix = "Internet"
#     }
# }

# resource "azurerm_subnet_network_security_group_association" "db-nsg-assoc" {
#     subnet_id = azurerm_subnet.db-subnet.id
#     network_security_group_id = azurerm_network_security_group.db-nsg.id
# }