#!/usr/bin/env bash
# Called by Vault Agent after each certificate render. Must always exit 0: a missing
# service would otherwise make the agent treat the render as failed.
for svc in nginx apache2; do
  if systemctl is-active --quiet "$svc"; then
    systemctl reload "$svc" || true
  fi
done
exit 0
