output "application_gateway_public_ip" {
  value       = module.app_gateway.public_ip
  description = "Point your Hostinger A-records (@ and ghee) to this IP address."
}

output "bastion_host_dns" {
  value       = module.networking.bastion_public_ip
  description = "Public IP allocated for secure Bastion access."
}