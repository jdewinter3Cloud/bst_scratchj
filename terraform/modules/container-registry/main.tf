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
  acr_sku_name   = "Basic"
}

resource "azurerm_container_registry" "main_acr" {
  #checkov:skip=CKV_AZURE_137: Ensure ACR admin account is disabled
  #checkov:skip=CKV_AZURE_139: Ensure ACR set to disable public networking
  #checkov:skip=CKV_AZURE_163: Enable vulnerability scanning for container images.
  #checkov:skip=CKV_AZURE_164: Ensures that ACR uses signed/trusted images.
  #checkov:skip=CKV_AZURE_165: Ensure geo-replicated container registries to match multi-region container deployments.
  #checkov:skip=CKV_AZURE_166: Ensure container image quarantine, scan, and mark images verified
  #checkov:skip=CKV_AZURE_167: Ensure a retention policy is set to cleanup untagged manifests.

  # Check: CKV_AZURE_137: "Ensure ACR admin account is disabled"
  #         Notes: Will fire if var.admin_enabled is false.  Not a good idea anyway
  #                but may be useful for testing and initial setup.
  # Check: CKV_AZURE_139: "Ensure ACR set to disable public networking"
  #         Guide: https://docs.bridgecrew.io/docs/ensure-azure-acr-is-set-to-disable-public-networking
  #         NOTES: Disabling public network access is not supported for the SKU Basic. For more information, please visit https://aka.ms/acr/private-link.
  # Check: CKV_AZURE_163: "Enable vulnerability scanning for container images"
  #         Notes: assumes will be {"Standard", "Premium"}, then switch for ACR container scanning
  # Check: CKV_AZURE_164: "Ensures that ACR uses signed/trusted images."
  #         Notes: assumes will be {"Premium"}, then switch trust_policy
  # Check: CKV_AZURE_165: "Ensure geo-replicated container registries to match multi-region container deployments."
  #         Notes: assumes will be {"Premium"}, then switch georeplications
  # Check: CKV_AZURE_166: "Ensure container image quarantine, scan, and mark images verified"
  #         Notes: assumes will be {"Premium"}, then switch quarantine_policy_enabled
  # Check: CKV_AZURE_167: "Ensure a retention policy is set to cleanup untagged manifests."
  #         Notes: assumes will be {"Premium"}, then switch retention_policy


  name                = "${var.adjusted_prefix}0acr0${var.location}0${var.common_suffix}"
  location            = var.location
  resource_group_name = var.rg_name

  admin_enabled                 = var.admin_enabled
  sku                           = local.acr_sku_name
  public_network_access_enabled = true

  tags = (merge(
    var.tags,
    tomap({})
  ))

  lifecycle {
    ignore_changes = [tags]
  }
}
