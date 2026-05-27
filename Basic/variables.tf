variable "location" {
    description = "location for all"
    type = string
    default = "Central India"
}

variable "vnetadd" {
    description = "main vnet range"
    type = list(string)
    default = ["10.0.0.0/16"]
}

variable "webadd" {
    description = "subnet 1 address prefix"
    type = list(string)
    default = ["10.0.1.0/24"]
}

variable "appadd" {
    description = "subnet 2 address prefix"
    type = list(string)
    default = ["10.0.2.0/24"]
}

variable "appvm1name" {
    description = "app vm 1 name"
    type = string
    default = "app-vm-1"
}

variable "appvm1size" {
    description = "app vm 1 size"
    type = string
    default = "Standard_B2ats_v2"
}

variable "appvmusr" {
    description = "app vm  username"
    type = string
    default = "noelmc9812"
    sensitive = true
}

variable "appvmpwd" {
    description = "app vm  password"
    type = string
    default = "Azure@12345"
    sensitive = true
}

variable "webvm1name" {
    description = "web vm 1 name"
    type = string
    default = "web-vm-1"
}


variable "webvm1size" {
    description = "web vm 1 size"
    type = string
    default = "Standard_B2ats_v2"
}

variable "webvmusr" {
    description = "web vm 1 username"
    type = string
    default = "noelmc9812"
    sensitive = true
}

variable "webvmpwd" {
    description = "web vm 1 password"
    type = string
    default = "Azure@12345"
    sensitive = true
}

variable "image-publisher" {
    description = "source image publisher"
    type = string
    default = "Canonical"
}

variable "image-version" {
    description = "source image version"
    type = string
    default = "latest"
}

variable "image-offer" {
    description = "source image offer"
    type = string
    default = "0001-com-ubuntu-server-jammy"
}

variable "image-sku" {
    description = "source image sku"
    type = string
    default = "22_04-lts"
}

