variable "location" {
  type        = string
  description = "Name of the region that the resources will be deployed to."
}

variable "rg_name" {
  type        = string
  description = "Name of the resource group to create any resources under."
}

variable "common_prefix" {
  type        = string
  description = "Common prefix to use when naming resources."
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
}

variable "acr_id" {
  type        = string
}

variable "acr_name" {
  type        = string
}

variable "acr_login_server" {
  type        = string
}

variable "app_insights_connection_string" {
  type        = string
}

variable "image_name" {
  type        = string
}

variable "image_tag" {
  type        = string
}

variable "bob" {
  type        = string
}
