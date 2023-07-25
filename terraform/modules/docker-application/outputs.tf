output "site_information" {
  description = "Information about the deployed site."
  value = {
      image_name       = var.image_name
      image_tag = var.image_tag
      host_name = azurerm_app_service.example.default_site_hostname
    }
}
