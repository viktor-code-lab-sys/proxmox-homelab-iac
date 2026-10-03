#!/usr/bin/env bash
# Shared settings for the mirror scripts. Run them ONLY on the mirror host: it is the
# single machine of the lab that is allowed to reach the internet.
# shellcheck disable=SC2034
REGISTRY="${REGISTRY:-registry.homelab.example}"
ROBOT_USER="${ROBOT_USER:-robot\$containerd-pull}"

registry_login() {
  : "${ROBOT_SECRET:?export ROBOT_SECRET first}"
  printf '%s' "$ROBOT_SECRET" | oras login "$REGISTRY" -u "$ROBOT_USER" --password-stdin >/dev/null
}
