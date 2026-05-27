output "public-vm-ip" {
  value = azurerm_public_ip.pubip.ip_address
}

output "private-vm-ip" {
  value = azurerm_network_interface.privnic.private_ip_address
}

output "lb-pip" {
  value = azurerm_public_ip.lb-pip.ip_address

}

output "nat-ip" {
  value = azurerm_public_ip.nat-ip.ip_address
}

output "pubvm-size" {
  value = azurerm_linux_virtual_machine.pub-vm.size
}

output "privvm-size" {
  value = azurerm_linux_virtual_machine.privvm.size
}



