output "nat-pip" {
    value = azurerm_public_ip.nat-pip.ip_address
}

output "webvm1privip" {
    value = azurerm_network_interface.web-nic1.private_ip_address
}

output "appvm1privip" {
    value = azurerm_network_interface.app-nic1.private_ip_address
}