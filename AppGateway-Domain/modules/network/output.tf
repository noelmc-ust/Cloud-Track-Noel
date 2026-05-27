output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}
output "app_subnet_id" {
  value = azurerm_subnet.app.id
}
output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}
output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_pip.ip_address
}
