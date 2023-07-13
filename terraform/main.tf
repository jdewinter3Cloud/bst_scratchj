provider "azurerm" {
  features {}
#   subscription_id = local.subscription_id
}

locals {
#   subscription_id      = "ID"
#   macroservice_name    = "name"
  servicebus_namespace = "A-service-bus-dev"
  prefix = "BST-test"
  location = "westus"
}

resource "azurerm_resource_group" "test" {
    name = "${local.prefix}-resources"
    location = "${local.location}"
}

module "servicebus" {
#   for_each = local.bar
  source               = "./modules/service-bus"

  location             = azurerm_resource_group.test.location
  rg_name               = azurerm_resource_group.test.name

  namespace            = "${local.prefix}-sevicebusn01s"
#   servicebus_namespace = each.value

  servicebus_objects = [
    # {
    #   topic_name        = "x"
    #   subscription_name = "x"
    # },
    {
      topic_name        = "y"
      subscription_name = "y"
    }
  ]
}

output "listen_connection_string" {
  value       = module.servicebus.listen_connection_string
  sensitive = true
}

output "send_connection_string" {
  value       = module.servicebus.send_connection_string
  sensitive = true
}

# resource “azurerm_storage_account” “test” {

# name = “xyzstorageaccount09”

# resource_group_name = “${azurerm_resource_group.test.name}”

# location = “${azurerm_resource_group.test.location}”

# account_tier = “Standard”

# account_replication_type = “LRS”

# }

# resource “azurerm_app_service_plan” “test” {

# name = “azure-functions-test-service-plan”

# location = “${azurerm_resource_group.test.location}”

# resource_group_name = “${azurerm_resource_group.test.name}”

# kind = “FunctionApp”

# sku {

# tier = “Dynamic”

# size = “Y1”

# }

# }

# resource “azurerm_function_app” “test” {

# name = “test-xyzcompany-functions”

# location = “${azurerm_resource_group.test.location}”

# resource_group_name = “${azurerm_resource_group.test.name}”

# app_service_plan_id = “${azurerm_app_service_plan.test.id}”

# storage_connection_string = “${azurerm_storage_account.test.primary_connection_string}”

# app_settings = {

# “ServiceBusConnectionString” = “some-value”

# }

# }