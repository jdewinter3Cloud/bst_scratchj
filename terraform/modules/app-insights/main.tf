terraform {
  required_version = ">= 1.4.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
}

resource "azurerm_log_analytics_workspace" "monitor" {
  name                = "app-insights-workspace"
  location            = var.location
  resource_group_name = var.rg_name

  retention_in_days = 30
  sku               = "pergb2018"

  tags = (merge(
    var.tags,
    tomap({})
  ))

  timeouts {}

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_insights" "monitor" {
  name                = "app-insights"
  location            = var.location
  resource_group_name = var.rg_name

  application_type    = "web"
  sampling_percentage = 0
  workspace_id        = azurerm_log_analytics_workspace.monitor.id

  tags = (merge(
    var.tags,
    tomap({})
  ))

  timeouts {}

  lifecycle {
    ignore_changes = [tags]
  }
}
