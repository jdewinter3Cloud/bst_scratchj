# Terraform Module: Azure Container Registry

This module provides simple support for incorporating an Azure Container Registry
into the project.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.4.2 |
| azurerm | =2.71.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | =2.71.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.main_acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/container_registry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adjusted\_prefix | Adjusted prefix to use when naming resources. | `string` | n/a | yes |
| admin\_enabled | Whether to allow admin access to the ACR for logging in. | `bool` | `false` | no |
| common\_suffix | Common suffix to use when naming resources. | `string` | n/a | yes |
| location | Name of the region that the resources will be deployed to. | `string` | n/a | yes |
| rg\_name | Name of the resource group to create any resources under. | `string` | n/a | yes |
| tags | Base set of tags to use with the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password | Admin password for the ACR, if admin\_enabled is true. |
| admin\_username | Admin user name for the ACR, if admin\_enabled is true. |
| id | ID for the ACR. |
| login\_server | Url name of the ACR for use in logging in. |
| name | Proper name of the ACR. |
<!-- END_TF_DOCS -->
