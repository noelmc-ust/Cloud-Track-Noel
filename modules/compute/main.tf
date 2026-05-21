resource "azurerm_network_interface" "fitness_nic" {
  name                = "fitness-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "fitness_nsg" {
  network_interface_id      = azurerm_network_interface.fitness_nic.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_linux_virtual_machine" "fitness_vm" {
  name                            = "fitness-tracker-vm"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B1ms"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  custom_data                     = base64encode(file("${path.module}/scripts/appsetup.sh"))

  network_interface_ids = [azurerm_network_interface.fitness_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}


resource "azurerm_network_interface" "ghee_nic" {
  name                = "ghee-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ghee_nsg" {
  network_interface_id      = azurerm_network_interface.ghee_nic.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_linux_virtual_machine" "ghee_vm" {
  name                            = "organic-ghee-vm"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B1ms"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  custom_data                     = base64encode(file("${path.module}/scripts/setup.sh"))

  network_interface_ids = [azurerm_network_interface.ghee_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}