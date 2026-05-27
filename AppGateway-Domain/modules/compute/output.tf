output "fitness_vm_private_ip" {
  value = azurerm_network_interface.fitness_nic.ip_configuration[0].private_ip_address
}
output "ghee_vm_private_ip" {
  value = azurerm_network_interface.ghee_nic.ip_configuration[0].private_ip_address
}