variable "rs_location" {
  description = "resource group location"
  type        = string
  default     = "Central India"
}

variable "vnet-addr" {
  description = "Vnet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "pubsubadd" {
  description = "public subnet address prefix"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "privsubadd" {
  description = "private subnet address prefix"
  type        = list(string)
  default     = ["10.0.2.0/24"]

}

variable "pub-vm-name" {
  description = "public vm name"
  type        = string
  default     = "pub-vm"
}

variable "priv-vm-name" {
  description = "private vm name"
  type        = string
  default     = "priv-vm"
}

variable "vmsize" {
  description = "vm size"
  type        = string
  default     = "Standard_B2ats_v2"
}

variable "usr" {
  description = "Username"
  type        = string
  default     = "noelmc9812"
}

variable "pwd" {
  description = "Password"
  type        = string
  default     = "Azurenmc@12345"
  sensitive = true
}

variable "caching" {
  description = "caching"
  type        = string
  default     = "ReadWrite"
}

variable "storage-account" {
  description = "storage_account_type"
  type        = string
  default     = "Standard_LRS"
}

variable "publisher" {
  description = "publisher"
  type        = string
  default     = "Canonical"
}

variable "image-version" {
  description = "image-version"
  type        = string
  default     = "latest"
}

variable "sku" {
  description = "image-sku"
  type        = string
  default     = "22_04-lts"

}

variable "offer" {
  description = "offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "lb-name" {
  description = "lb config name"
  type        = string
  default     = "load-balancer-ip"

}