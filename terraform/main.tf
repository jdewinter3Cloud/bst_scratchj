# https://learn.microsoft.com/en-us/azure/api-management/quickstart-terraform?tabs=azure-cli
# https://www.linkedin.com/pulse/terraform-azure-api-management-c%C6%B0%C6%A1ng-v%C5%A9/

variable "xx" {
  type        = string
  description = "xx."
}

locals {
#   subscription_id      = "ID"
#   macroservice_name    = "name"
  servicebus_namespace = "A-service-bus-dev"
  api_name = "bob"
  prefix   = "BST-3C"
  location = "eastus"
  common_suffix = "-test"

  acr_image_name = "service-xxx"
  acr_image_tag = "latest"

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

#
# Provide for the necessary infrastructure to host the image.
#
module "docker-application" {
  source   = "./modules/docker-application"

  rg_name         = azurerm_resource_group.test.name
  location        = azurerm_resource_group.test.location
  tags            = local.common_tags
  common_prefix   = local.prefix
  adjusted_prefix = local.adjusted_prefix
  common_suffix   = local.common_suffix

  acr_id           = module.container-registry.id
  acr_name         = module.container-registry.name
  acr_login_server = module.container-registry.login_server

  app_insights_connection_string = one(module.application-insights[*].connection_string)

  image_name = local.acr_image_name
  image_tag  = local.acr_image_tag
}

#
# Make sure to provide for an ACR to hold the images.
#
module "container-registry" {
  source = "./modules/container-registry"

  rg_name         = azurerm_resource_group.test.name
  location        = azurerm_resource_group.test.location
  tags            = local.common_tags
  adjusted_prefix = local.adjusted_prefix
  common_suffix   = local.common_suffix

  admin_enabled = var.allow_admin_acr_access
}

#
# Optionally enable application insights to provide observability.
#
module "application-insights" {
  source = "./modules/app-insights"
  count  = var.allocate_application_insights == true ? 1 : 0

  rg_name  = azurerm_resource_group.test.name
  location = azurerm_resource_group.test.location
  tags     = local.common_tags
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
