output "connection_string" {
  description = "Connection string to connect up to created instance of AppInsights."
  value       = azurerm_application_insights.monitor.connection_string
}
