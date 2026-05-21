resource "azurerm_public_ip" "appgw_pip" {
  name                = "appgw-edge-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gw" {
  name                = "production-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = "port-443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }


  ssl_certificate {
    name     = "flowforge-multi-domain-cert"
    data     = filebase64(var.pfx_certificate_path)
    password = var.pfx_certificate_password
  }


  backend_address_pool {
    name         = "fitness-pool"
    ip_addresses = [var.fitness_vm_private_ip]
  }

  backend_address_pool {
    name         = "ghee-pool"
    ip_addresses = [var.ghee_vm_private_ip]
  }

  backend_http_settings {
    name                  = "http-settigs"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "fitness-https"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "port-443"
    protocol                       = "Https"
    ssl_certificate_name           = "flowforge-multi-domain-cert"
    host_name                      = "flowforge.fun"
  }

  http_listener {
    name                           = "ghee-https"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "port-443"
    protocol                       = "Https"
    ssl_certificate_name           = "flowforge-multi-domain-cert"
    host_name                      = "ghee.flowforge.fun"
  }


  request_routing_rule {
    name                       = "fitness-route"
    rule_type                  = "Basic"
    http_listener_name         = "fitness-https"
    backend_address_pool_name  = "fitness-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 10
  }

  request_routing_rule {
    name                       = "ghee-route"
    rule_type                  = "Basic"
    http_listener_name         = "ghee-https"
    backend_address_pool_name  = "ghee-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 20
  }
}

output "public_ip" {
  value = azurerm_public_ip.appgw_pip.ip_address
}