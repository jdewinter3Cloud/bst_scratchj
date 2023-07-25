variable "location" {
  type        = string
  description = "Name of the region that the resources will be deployed to."
}

variable "rg_name" {
  type        = string
  description = "Name of the resource group to create any resources under."
}

variable "tags" {
  type = map(string)
}
