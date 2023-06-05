output "postgresql_administrator_login" {
  value       = var.create_server && var.create_mode == "Default" ? random_string.random_string[0].result : null
  description = "The Administrator login for PostgreSQL server. Exists only in case of creating server (create_server=true)."
  }

output "postgresql_server" {
  value       = var.create_server ? azurerm_postgresql_server.postgres_server : null
  description = "Created server object. Exists only in case of creating server (create_server=true)."
}

output "postgresql_databases" {
  value       = var.databases_config == null ? null : azurerm_postgresql_database.postgresql_database
  description = "Created database object. Exists only in case of creating databases (databases_config not empty)."
  sensitive = true
}