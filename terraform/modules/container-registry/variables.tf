variable "location" {
  type        = string
  description = "Name of the region that the resources will be deployed to."
}

variable "rg_name" {
  type        = string
  description = "Name of the resource group to create any resources under."
}

variable "adjusted_prefix" {
  type        = string
  description = "Adjusted prefix to use when naming resources."
}

variable "common_suffix" {
  type        = string
  description = "Common suffix to use when naming resources."
}

variable "tags" {
  type = map(string)
  description = "Base set of tags to use with the resource."
}

variable "admin_enabled" {
  type        = bool
  description = "Whether to allow admin access to the ACR for logging in."
  default =  false
}
