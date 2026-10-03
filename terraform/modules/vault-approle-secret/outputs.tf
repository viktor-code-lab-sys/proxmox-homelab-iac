output "secret_id" {
  description = "Generated secret_id; pass it to cloud-init only."
  value       = vault_approle_auth_backend_role_secret_id.this.secret_id
  sensitive   = true
}

output "accessor" {
  description = "Accessor of the secret_id, safe to log."
  value       = vault_approle_auth_backend_role_secret_id.this.accessor
}
