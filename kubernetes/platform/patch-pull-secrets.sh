#!/usr/bin/env bash
# Attach the Harbor pull secret to every ServiceAccount in a namespace and recreate
# pods that already failed. Helm charts create their own ServiceAccounts, which do
# not inherit imagePullSecrets from "default".
set -euo pipefail
ns="${1:?usage: $0 <namespace> [secret-name]}"
secret="${2:-harbor-pull-secret}"

for sa in $(kubectl get sa -n "$ns" -o jsonpath='{.items[*].metadata.name}'); do
  kubectl patch serviceaccount "$sa" -n "$ns" \
    -p "{\"imagePullSecrets\": [{\"name\": \"$secret\"}]}"
done
kubectl delete pods --all -n "$ns"
