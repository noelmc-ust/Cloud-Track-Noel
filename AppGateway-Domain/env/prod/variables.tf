variable "resource_group_name" {
  type    = string
  default = "flowforge-prod-rg"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "vnet_cidr" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "admin_username" {
  type    = string
  default = "azureprodadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "pfx_certificate_path" {
  type        = string
  description = "Path to the production certificate"
}

variable "pfx_certificate_password" {
  type      = string
  sensitive = true
}