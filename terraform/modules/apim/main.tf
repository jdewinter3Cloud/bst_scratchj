# https://azure.microsoft.com/en-au/pricing/details/api-management/#pricing

resource "azurerm_api_management" "api" {
  resource_group_name = var.rg_name
  location            = var.location

  name                = "apiservice-${var.api_name}"
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  sku_name            = var.sku_name

  tags = (merge(
    var.tags,
    tomap({})
  ))

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_api_management_api" "apis" {
  resource_group_name = var.rg_name
  api_management_name = azurerm_api_management.api.name

  for_each = {for v in var.apiAndOperation : v.name => v}

  name                = each.value.name
  revision            = "1"
  display_name        = each.value.name
  path                = each.value.path
  protocols           = ["https"]
  service_url           = each.value.service_url
  soap_pass_through     = false
  subscription_required = true
  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
  timeouts {}

#   tags = (merge(
#     var.tags,
#     tomap({})
#   ))

#   lifecycle {
#     ignore_changes = [tags]
#   }
}

resource "azurerm_api_management_api_operation" "apis" {
  resource_group_name = var.rg_name
  api_management_name = azurerm_api_management.api.name

  for_each = {for i in var.operations : i.operation_name => i}
  api_name            = each.value.name
  operation_id = each.value.operation_name
  display_name = each.value.operation_name
  method = each.value.method
  url_template = each.value.url_template
  depends_on = [azurerm_api_management_api.apis]
#   tags = (merge(
#     var.tags,
#     tomap({})
#   ))

#   lifecycle {
#     ignore_changes = [
#       request,response, tags
#     ]
#   }
}

resource "azurerm_api_management_api_operation_policy" "apis" {
    resource_group_name = var.rg_name
  api_management_name = azurerm_api_management.api.name
 
    for_each = {for i in var.operations : i.operation_name => i}
    api_name            = each.value.name
    operation_id        = each.value.operation_name
    xml_content = each.value.xml_content
    depends_on = [azurerm_api_management_api_operation.apis]

#   tags = (merge(
#     var.tags,
#     tomap({})
#   ))

#   lifecycle {
#     ignore_changes = [tags]
#   }
}

output "api_name" {
  value = azurerm_api_management.api.name
}
