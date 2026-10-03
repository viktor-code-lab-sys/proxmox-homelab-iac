# /etc/vault-agent/agent.hcl in the Vault Agent template.
# role-id is baked in; secret-id is written per VM by cloud-init and deleted after use.
pid_file = "/run/vault-agent.pid"

vault {
  address = "https://vault.homelab.example:8200"
}

auto_auth {
  method "approle" {
    mount_path = "auth/approle"
    config = {
      role_id_file_path                   = "/etc/vault-agent/role-id"
      secret_id_file_path                 = "/etc/vault-agent/secret-id"
      remove_secret_id_file_after_reading = true
    }
  }
  sink "file" {
    config = { path = "/etc/vault-agent/vault-token" }
  }
}

# Keeps the token alive across agent restarts (the one-time secret_id is gone by then).
cache {
  use_auto_auth_token = true
}

# Go templates cannot nest {{ }} inside arguments: build the parameter with printf.
template {
  contents    = "{{- with secret \"pki/issue/homelab\" (printf \"common_name=%s\" (env \"VM_FQDN\")) \"ttl=8760h\" -}}{{ .Data.certificate }}\n{{ .Data.ca_chain }}{{- end -}}"
  destination = "/etc/ssl/local/fullchain.pem"
  command     = "/usr/local/bin/reload-services.sh"
}

template {
  contents    = "{{- with secret \"pki/issue/homelab\" (printf \"common_name=%s\" (env \"VM_FQDN\")) \"ttl=8760h\" -}}{{ .Data.private_key }}{{- end -}}"
  destination = "/etc/ssl/local/privkey.pem"
  perms       = 0600
}
