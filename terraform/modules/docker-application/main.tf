terraform {
  required_version = ">= 1.4.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
}

locals {
  app_service_port = "5000"

  app_service_plan_capacity = 1
  app_service_plan_size     = "B1"
  app_service_plan_tier     = "Basic"
  app_service_plan_kind     = "linux"

  zero_bob = replace(var.bob, "_", "0")
}

resource "azurerm_app_service_plan" "example" {
  name                = "${var.common_prefix}-${var.bob}-${var.location}-${var.common_suffix}"
  location            = var.location
  resource_group_name = var.rg_name

  kind     = local.app_service_plan_kind
  reserved = true

  tags = (merge(
    var.tags,
    tomap({})
  ))

  sku {
    capacity = local.app_service_plan_capacity
    size     = local.app_service_plan_size
    tier     = local.app_service_plan_tier
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

locals {
  general_app_settings_map = {
    "DOCKER_ENABLE_CI"                    = "true"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.acr_login_server}"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "WEBSITES_PORT"                       = local.app_service_port
  }
  insights_app_settings_map = {
    enabled = {
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
    }
    disabled = {}

  }
  app_settings_map = (merge(
    local.general_app_settings_map,
    local.insights_app_settings_map[var.app_insights_connection_string != null ? "enabled" : "disabled"],
    local.insights_app_settings_map["disabled"]
  ))
}

resource "azurerm_app_service" "example" {
  #checkov:skip=CKV_AZURE_17: With this setting at True, normal browsers are not able to hit it.
  #checkov:skip=CKV_AZURE_80: Since docker images are used, the Net Framework version is not relevant.

  #checkov:skip=CKV_AZURE_13:needs further research
  #checkov:skip=CKV_AZURE_63:needs further research
  #checkov:skip=CKV_AZURE_65:needs further research
  #checkov:skip=CKV_AZURE_66:needs further research
  #checkov:skip=CKV_AZURE_78:needs further research
  #checkov:skip=CKV_AZURE_88:needs further research
  #checkov:skip=CKV_AZURE_213:needs further research

  # Check: CKV_AZURE_13: "Ensure App Service Authentication is set on Azure App Service"
  #         Guide: https://docs.bridgecrew.io/docs/bc_azr_general_2
  # Check: CKV_AZURE_17: "Ensure the web app has 'Client Certificates (Incoming client certificates)' set"
  #         Guide: https://docs.bridgecrew.io/docs/bc_azr_networking_7
  # Check: CKV_AZURE_63: "Ensure that App service enables HTTP logging"
  #         Guide: https://docs.bridgecrew.io/docs/ensure-that-app-service-enables-http-logging
  # Check: CKV_AZURE_65: "Ensure that App service enables detailed error messages"
  #         Guide: https://docs.bridgecrew.io/docs/tbdensure-that-app-service-enables-detailed-error-messages
  # Check: CKV_AZURE_66: "Ensure that App service enables failed request tracing"
  #         Guide: https://docs.bridgecrew.io/docs/ensure-that-app-service-enables-failed-request-tracing
  # Check: CKV_AZURE_78: "Ensure FTP deployments are disabled"
  #         Guide: https://docs.bridgecrew.io/docs/ensure-ftp-deployments-are-disabled
  # Check: CKV_AZURE_80: "Ensure that 'Net Framework' version is the latest, if used as a part of the web app"
  #         Guide: https://docs.bridgecrew.io/docs/ensure-that-net-framework-version-is-the-latest-if-used-as-a-part-of-the-web-app
  # Check: CKV_AZURE_88: "Ensure that app services use Azure Files"
  #         Guide: https://docs.bridgecrew.io/docs/ensure-that-app-services-use-azure-files
  # Check: CKV_AZURE_213: "Ensure that App Service configures health check"

  name                = "${var.common_prefix}-${var.bob}-${var.location}-${var.common_suffix}"
  location            = var.location
  resource_group_name = var.rg_name

  enabled = true

  app_service_plan_id     = azurerm_app_service_plan.example.id
  app_settings            = local.app_settings_map
  client_affinity_enabled = true
  client_cert_enabled     = false
  https_only              = true

  tags = (merge(
    var.tags,
    tomap({})
  ))

  identity {
    identity_ids = [
      azurerm_user_assigned_identity.acr_identity.id
    ]
    type = "UserAssigned"
  }

  site_config {
    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html",
    ]
    http2_enabled                        = true
    linux_fx_version                     = "DOCKER|${var.acr_login_server}/${var.image_name}:${var.image_tag}"
    use_32_bit_worker_process            = true
    acr_use_managed_identity_credentials = true
    acr_user_managed_identity_client_id  = azurerm_user_assigned_identity.acr_identity.client_id
  }

  logs {
    detailed_error_messages_enabled = true
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_container_registry_webhook" "webhook" {
  name                = "${var.adjusted_prefix}0acrwh0${local.zero_bob}0${var.common_suffix}"
  location            = var.location
  resource_group_name = var.rg_name

  actions       = ["push"]
  registry_name = var.acr_name
  scope         = "${var.image_name}:${var.image_tag}"

  # Possible Improvement: This workaround is used in lieu of the azurerm provider
  #     not having proper support for obtaining the CI_CD_URL value.
  # See: See https://github.com/hashicorp/terraform-provider-azurerm/issues/9593
  #
  # CI_CD_URL:
  service_uri = "https://${azurerm_app_service.example.site_credential[0].username}:${azurerm_app_service.example.site_credential[0].password}@${lower(azurerm_app_service.example.name)}.scm.azurewebsites.net/docker/hook"
  # CI_CD_URL:

  tags = (merge(
    var.tags,
    tomap({})
  ))

  lifecycle {
    ignore_changes = [tags]
  }
}

#
# Create a managed identity to allow the App Service to pull limages from the ACR.
#
resource "azurerm_user_assigned_identity" "acr_identity" {
  name                = "${var.common_prefix}_${var.bob}_id_${var.location}_${var.common_suffix}"
  location            = var.location
  resource_group_name = var.rg_name

  tags = (merge(
    var.tags,
    tomap({})
  ))

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "acr_role" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
}
