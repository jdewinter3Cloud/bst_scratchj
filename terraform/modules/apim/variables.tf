variable "rg_name" {
  type        = string
  description = "Name of the resource group that will contain the service bus resources."
}

variable "location" {
  type        = string
  default     = "westus"
  description = "Location where the resources will be deployed to."
  validation {
    condition     = contains(["westus", "eastus"], var.location)
    error_message = "Err: environment must be one of: 'westus', 'eastus'."
  }
}

variable "tags" {
  type = map(string)
  description = "Base set of tags to use with the resource."
}

variable "operations" {
  	type = list(object({
        name = string
        operation_name = string
        method = string
        url_template = string
		xml_content = string
	}))
}

variable "apiAndOperation" {
  type = list(object({
    name = string
    path = string
    service_url = string
  }))
}

variable "api_name" {
  type        = string
}

variable "publisher_email" {
  type        = string
}

variable "publisher_name" {
  type        = string
}

variable "sku_name" {
  type        = string
}

