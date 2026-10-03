#!/usr/bin/env bash
# Atlantis as a container on its own VM. Tokens come from the environment, never
# from this file: export GITLAB_TOKEN and GITLAB_WEBHOOK_SECRET first.
set -euo pipefail
: "${GITLAB_TOKEN:?export GITLAB_TOKEN (legacy PAT, api scope)}"
: "${GITLAB_WEBHOOK_SECRET:?export GITLAB_WEBHOOK_SECRET}"

docker run -d --name atlantis \
  --restart unless-stopped \
  --user root \
  -p 4141:4141 \
  -v "$HOME/atlantis-data:/atlantis-data" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -v /etc/ssl/local:/etc/ssl/local:ro \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  ghcr.io/runatlantis/atlantis:latest \
  server \
  --gitlab-hostname=gitlab.homelab.example \
  --gitlab-user=root \
  --gitlab-token="$GITLAB_TOKEN" \
  --gitlab-webhook-secret="$GITLAB_WEBHOOK_SECRET" \
  --repo-allowlist='gitlab.homelab.example/*' \
  --ssl-cert-file=/etc/ssl/local/fullchain.pem \
  --ssl-key-file=/etc/ssl/local/privkey.pem \
  --repo-config=/atlantis-data/repos.yaml \
  --port=4141
