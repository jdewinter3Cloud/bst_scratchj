# Terraform Module: App-Insights

This module provides simple support for incorporating an application insights
instance into a project.

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
| [azurerm_application_insights.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | Name of the region that the resources will be deployed to. | `string` | n/a | yes |
| rg\_name | Name of the resource group to create any resources under. | `string` | n/a | yes |
| tags | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| connection\_string | Connection string to connect up to created instance of AppInsights. |
<!-- END_TF_DOCS -->
