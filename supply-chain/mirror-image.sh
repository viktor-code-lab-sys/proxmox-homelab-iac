#!/usr/bin/env bash
# Pre-warm a proxy-cache project, so the first cluster pull does not wait on the internet.
# Usage: mirror-image.sh <image:tag> <proxy-project>   e.g. grafana/grafana:11.3.0 dockerhub-proxy
set -euo pipefail
# shellcheck source=/dev/null
. "$(dirname "$0")/common.sh"
image="${1:?usage: $0 <image:tag> <proxy-project>}"
project="${2:?}"

docker pull "${REGISTRY}/${project}/${image}"
echo "cached ${REGISTRY}/${project}/${image}"
