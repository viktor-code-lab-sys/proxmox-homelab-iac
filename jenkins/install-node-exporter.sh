#!/usr/bin/env bash
# Executed on the target VM through `ssh ... bash -s`. Idempotent: exits early when
# the exporter already answers on the expected port.
set -euo pipefail
: "${ROBOT_SECRET:?}" "${REGISTRY:?}" "${VERSION:?}" "${PORT:?}"
LISTEN_ARG="${LISTEN_ARG:-}"

if systemctl is-active --quiet node_exporter && curl -sf "http://localhost:${PORT}/metrics" >/dev/null; then
  echo "node_exporter already running on ${PORT}, skipping"
  exit 0
fi

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT
cd "$workdir"

# shellcheck disable=SC2016  # literal $ in the robot account name
printf '%s' "$ROBOT_SECRET" | oras login "$REGISTRY" -u 'robot$containerd-pull' --password-stdin
oras pull "${REGISTRY}/k8s-binaries/node_exporter:${VERSION}"
tar xzf ./node_exporter*.tar.gz
sudo install -m 0755 node_exporter-*.linux-amd64/node_exporter /usr/local/bin/node_exporter

id -u node_exporter >/dev/null 2>&1 || sudo useradd --no-create-home --shell /usr/sbin/nologin node_exporter

sudo tee /etc/systemd/system/node_exporter.service >/dev/null <<UNIT
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter ${LISTEN_ARG}
Restart=on-failure

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl restart node_exporter
sleep 1
curl -sf "http://localhost:${PORT}/metrics" >/dev/null
echo "node_exporter started on ${PORT}"
