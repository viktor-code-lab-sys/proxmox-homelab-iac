#!/usr/bin/env bash
# Store any local file (binary, tarball, manifest, SQL) in the registry as an OCI artifact.
# Usage: mirror-file.sh <file> <name> <tag> [artifact-type]
# Pull on a lab machine: oras pull $REGISTRY/k8s-binaries/<name>:<tag>
# The file is restored under its own basename, so consumers must use that name.
set -euo pipefail
# shellcheck source=/dev/null
. "$(dirname "$0")/common.sh"
file="${1:?usage: $0 <file> <name> <tag> [artifact-type]}"
name="${2:?}"
tag="${3:?}"
type="${4:-application/octet-stream}"

registry_login
# ORAS refuses absolute paths by default, so push from the file's own directory.
cd "$(dirname "$file")"
oras push "${REGISTRY}/k8s-binaries/${name}:${tag}" --artifact-type "$type" "$(basename "$file")"
