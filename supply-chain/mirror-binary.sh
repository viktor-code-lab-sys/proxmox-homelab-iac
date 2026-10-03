#!/usr/bin/env bash
# Download a release asset from the internet and store it in the registry.
# Usage: mirror-binary.sh <url> <name> <tag> [sha256]
set -euo pipefail
url="${1:?usage: $0 <url> <name> <tag> [sha256]}"
name="${2:?}"
tag="${3:?}"
sha="${4:-}"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT
file="${workdir}/$(basename "$url")"
curl -fsSL -o "$file" "$url"
if [[ -n "$sha" ]]; then
  echo "${sha}  ${file}" | sha256sum -c -
fi
"$(dirname "$0")/mirror-file.sh" "$file" "$name" "$tag"
