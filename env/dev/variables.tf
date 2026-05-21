variable "resource_group_name" {
  type        = string
  default     = "flowforge-enterprise-rg"
}

variable "location" {
  type        = string
  default     = "East US"
}

variable "vnet_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "pfx_certificate_path" {
  type        = string
  description = "Absolute or relative path to your flowforge-ssl.pfx file"
}

variable "pfx_certificate_password" {
  type        = string
  sensitive   = true
}