terraform {
  required_version = ">= 1.4.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
      }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 12 # Note: This is set in concert with azurerm_storage_account.tfstate.name to use the full 24 characters allowed
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "bst_integration_tfstate${random_string.resource_code.result}"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
#checkov:skip=CKV2_AZURE_1:needs further research
#checkov:skip=CKV2_AZURE_18:needs further research
#checkov:skip=CKV2_AZURE_33:needs further research
#checkov:skip=CKV2_AZURE_38:needs further research
#checkov:skip=CKV_AZURE_33:needs further research
#checkov:skip=CKV_AZURE_44:needs further research
#checkov:skip=CKV_AZURE_59:needs further research
#checkov:skip=CKV_AZURE_190:needs further research
#checkov:skip=CKV_AZURE_206:needs further research

  name                     = "dwt0tfstate0${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
#checkov:skip=CKV2_AZURE_21:needs further research
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

output "resource_group" {
value = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
value = azurerm_storage_container.tfstate.name
}

# Suppressed Checkov Checks, for more research
#
# Check: CKV2_AZURE_1: "Ensure storage for critical data are encrypted with Customer Managed Key"
#         Guide: https://docs.bridgecrew.io/docs/ensure-storage-for-critical-data-are-encrypted-with-customer-managed-key
# Check: CKV2_AZURE_18: "Ensure that Storage Accounts use customer-managed key for encryption"
#         Guide: https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-use-customer-managed-key-for-encryption
# Check: CKV2_AZURE_21: "Ensure Storage logging is enabled for Blob service for read requests"
#         Guide: https://docs.bridgecrew.io/docs/ensure-storage-logging-is-enabled-for-blob-service-for-read-requests
# Check: CKV_AZURE_33: "Ensure Storage logging is enabled for Queue service for read, write and delete requests"
#         Guide: https://docs.bridgecrew.io/docs/enable-requests-on-storage-logging-for-queue-service
# Check: CKV2_AZURE_33: "Ensure storage account is configured with private endpoint"
# Check: CKV_AZURE_44: "Ensure Storage Account is using the latest version of TLS encryption"
#         Guide: https://docs.bridgecrew.io/docs/bc_azr_storage_2
# Check: CKV_AZURE_59: "Ensure that Storage accounts disallow public access"
#         Guide: https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-disallow-public-access
# Check: CKV_AZURE_190: "Ensure that Storage blobs restrict public access"
# Check: CKV_AZURE_206: "Ensure that Storage Accounts use replication"
