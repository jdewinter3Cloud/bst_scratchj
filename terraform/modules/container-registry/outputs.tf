
output "name" {
  description = "Proper name of the ACR."
  value       = azurerm_container_registry.main_acr.name
}

output "id" {
  description = "ID for the ACR."
  value       = azurerm_container_registry.main_acr.id
}

output "login_server" {
  description = "Url name of the ACR for use in logging in."
  value       = azurerm_container_registry.main_acr.login_server
}

output "admin_username" {
  description = "Admin user name for the ACR, if admin_enabled is true."
  value       = azurerm_container_registry.main_acr.admin_username
}

output "admin_password" {
  description = "Admin password for the ACR, if admin_enabled is true."
  value       = azurerm_container_registry.main_acr.admin_password
}
