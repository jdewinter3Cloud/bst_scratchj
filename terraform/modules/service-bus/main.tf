resource "azurerm_servicebus_namespace" "this" {
  name                = var.namespace
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  tags = {
      source = "terraform"
  }
}

resource "azurerm_servicebus_topic" "this" {
  for_each     = {for k, v in var.servicebus_objects :  k => v}
  name         = each.value.topic_name

  namespace_id = azurerm_servicebus_namespace.this.id

#   resource_group_name = var.rg_name


  enable_partitioning = true
}

resource "azurerm_servicebus_subscription" "this" {
  for_each                             = azurerm_servicebus_topic.this
  name                                 = var.servicebus_objects[index(var.servicebus_objects.*.topic_name, each.value.name)].subscription_name
  topic_id                             = each.value.id
  max_delivery_count                   = 1
  dead_lettering_on_message_expiration = true
}

resource "azurerm_servicebus_namespace_authorization_rule" "send" {
  name                = "servicebus_send_auth_rule"
  namespace_id = azurerm_servicebus_namespace.this.id

  listen = false
  send   = true
  manage = false
}

resource "azurerm_servicebus_namespace_authorization_rule" "listen" {
  name                = "servicebus_listen_auth_rule"
  namespace_id = azurerm_servicebus_namespace.this.id

  listen = true
  send   = false
  manage = false
}

output "send_connection_string" {
  description = "cs"
  value       = azurerm_servicebus_namespace_authorization_rule.send.primary_connection_string
}

output "listen_connection_string" {
  description = "cs"
  value       = azurerm_servicebus_namespace_authorization_rule.listen.primary_connection_string
}
