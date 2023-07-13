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

variable "namespace" {
  type        = string
  description = "Namespace to use for the queues."
}

variable "servicebus_objects" {
    type = list(map(string))
}