# https://learn.microsoft.com/en-us/azure/api-management/quickstart-terraform?tabs=azure-cli
# https://www.linkedin.com/pulse/terraform-azure-api-management-c%C6%B0%C6%A1ng-v%C5%A9/

provider "azurerm" {
  features {}
#   subscription_id = local.subscription_id
}

locals {
#   subscription_id      = "ID"
#   macroservice_name    = "name"
  servicebus_namespace = "A-service-bus-dev"
  api_name = "bob"
  prefix = "BST-test"
  location = "westus"
  common_tags = {
    Component   = "bst-test"
    Environment = "Development"
  }

  apis = [
    {
      name = "exampleApi"
      path = "example"
      service_url = "https://www.google.com/example"
    },
  ]
  operations = [ 
	{
        name = "exampleApi"
		operation_name = "getExample"
        method = "GET"
        url_template = "/example"
		xml_content = <<XML
            <policies>
                <inbound>
					<base />
                </inbound>
                <backend>
                    <base />
                </backend>
                <outbound>
                    <base />
                </outbound>
                <on-error>
                    <base />
                </on-error>
            </policies>
        XML
    },  
    ]
}

resource "azurerm_resource_group" "test" {
    name = "${local.prefix}-resources"
    location = "${local.location}"

  tags = (merge(
    local.common_tags,
    tomap({})
  ))

  lifecycle {
    ignore_changes = [tags]
  }

}

module "servicebus" {
#   for_each = local.bar
  source               = "./modules/service-bus"

  location             = azurerm_resource_group.test.location
  rg_name               = azurerm_resource_group.test.name
  tags = (merge(
    local.common_tags,
    tomap({})
  ))

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

module "apim" {
	source = "./modules/apim"

    rg_name = azurerm_resource_group.test.name
    location = azurerm_resource_group.test.location
    tags = (merge(
        local.common_tags,
        tomap({})
    ))

    operations = local.operations
    apiAndOperation = local.apis
    api_name = local.api_name
    publisher_email = "jdewinter@3cloudsolutions.com"
    publisher_name = "3cloud"
    sku_name = "Developer_1"
}

resource "azurerm_user_assigned_identity" "example" {
  resource_group_name = azurerm_resource_group.test.name
  location = "westus2"
    tags = (merge(
        local.common_tags,
        tomap({})
    ))

  name                = "example"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_load_test" "example" {
  resource_group_name = azurerm_resource_group.test.name
  location = "westus2"
    tags = (merge(
        local.common_tags,
        tomap({})
    ))

  name                = "example"

  lifecycle {
    ignore_changes = [tags]
  }
}

output "listen_connection_string" {
  value       = module.servicebus.listen_connection_string
  sensitive = true
}

output "send_connection_string" {
  value       = module.servicebus.send_connection_string
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.test.name
}

output "api_management_service_name" {
  value = module.apim.api_name
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