#!/usr/bin/env bash
# Pull a Helm chart from a public repo and push it to the registry's OCI chart project.
# Usage: mirror-chart.sh <repo-name> <repo-url> <chart> <version>
set -euo pipefail
# shellcheck source=/dev/null
. "$(dirname "$0")/common.sh"
repo="${1:?usage: $0 <repo-name> <repo-url> <chart> <version>}"
url="${2:?}"
chart="${3:?}"
version="${4:?}"

: "${ROBOT_SECRET:?export ROBOT_SECRET first}"
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

helm repo add "$repo" "$url" --force-update >/dev/null
helm pull "${repo}/${chart}" --version "$version" -d "$workdir"
printf '%s' "$ROBOT_SECRET" | helm registry login "$REGISTRY" -u "$ROBOT_USER" --password-stdin
helm push "${workdir}/${chart}-${version}.tgz" "oci://${REGISTRY}/helm-charts"
