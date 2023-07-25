# Terraform Module: App-Insights

This module provides support for incorporating a docker-based application into
the project.

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
| [azurerm_app_service.example](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/app_service) | resource |
| [azurerm_app_service_plan.example](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/app_service_plan) | resource |
| [azurerm_container_registry_webhook.webhook](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/container_registry_webhook) | resource |
| [azurerm_role_assignment.acr_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.acr_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acr\_id | n/a | `string` | n/a | yes |
| acr\_login\_server | n/a | `string` | n/a | yes |
| acr\_name | n/a | `string` | n/a | yes |
| adjusted\_prefix | Adjusted prefix to use when naming resources. | `string` | n/a | yes |
| app\_insights\_connection\_string | n/a | `string` | n/a | yes |
| bob | n/a | `string` | n/a | yes |
| common\_prefix | Common prefix to use when naming resources. | `string` | n/a | yes |
| common\_suffix | Common suffix to use when naming resources. | `string` | n/a | yes |
| image\_name | n/a | `string` | n/a | yes |
| image\_tag | n/a | `string` | n/a | yes |
| location | Name of the region that the resources will be deployed to. | `string` | n/a | yes |
| rg\_name | Name of the resource group to create any resources under. | `string` | n/a | yes |
| tags | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| site\_information | Information about the deployed site. |
<!-- END_TF_DOCS -->
