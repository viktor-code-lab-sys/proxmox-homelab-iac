#!/usr/bin/env bash
# Runs on the Atlantis HOST (not in the container): logs in to Vault with the
# Atlantis AppRole, reads automation secrets from KV and writes an env file that
# the workflow sources. The official Atlantis image blocks extra binaries, so the
# secrets are prepared outside and mounted in.
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-https://vault.homelab.example:8200}"
ROLE_ID_FILE="${ROLE_ID_FILE:-/etc/vault-agent/atlantis-role-id}"
SECRET_ID_FILE="${SECRET_ID_FILE:-/etc/vault-agent/atlantis-secret-id}"
KV_PATH="${KV_PATH:-infra-secrets/terraform}"
OUT_FILE="${OUT_FILE:-$HOME/atlantis-data/tf-secrets.env}"
PROXMOX_ENDPOINT="${PROXMOX_ENDPOINT:-https://pve.homelab.example:8006}"
STATE_USER="${STATE_USER:-root}"
export VAULT_ADDR

VAULT_TOKEN="$(vault write -field=token auth/approle/login \
  role_id="$(cat "$ROLE_ID_FILE")" \
  secret_id="$(cat "$SECRET_ID_FILE")")"
export VAULT_TOKEN

secrets="$(vault kv get -format=json "$KV_PATH")"
field() { jq -r --arg k "$1" '.data.data[$k]' <<<"$secrets"; }

umask 077
cat > "$OUT_FILE" <<ENVEOF
TF_VAR_proxmox_api_token=$(field proxmox_api_token)
TF_VAR_fortigate_api_token=$(field fortigate_api_token)
TF_VAR_proxmox_endpoint=${PROXMOX_ENDPOINT}
TF_HTTP_USERNAME=${STATE_USER}
TF_HTTP_PASSWORD=$(field gitlab_token)
VAULT_TOKEN=${VAULT_TOKEN}
ENVEOF
echo "wrote $OUT_FILE (token TTL is short: run right before plan/apply)"
