#!/usr/bin/env bash
# Bake into the cloud-init templates. systemd-resolved treats ".lan" as a special-use
# name and never forwards it upstream, and the NSS "resolve" module gives no fallback,
# so internal names fail while `dig @server` works. Use plain glibc DNS instead.
set -euo pipefail
nameserver="${1:?usage: $0 <nameserver-ip> <search-domain>}"
search="${2:?usage: $0 <nameserver-ip> <search-domain>}"

sudo systemctl disable --now systemd-resolved
sudo systemctl mask systemd-resolved
sudo rm -f /etc/resolv.conf
printf 'nameserver %s\nsearch %s\n' "$nameserver" "$search" | sudo tee /etc/resolv.conf >/dev/null
sudo sed -i 's/^hosts:.*/hosts: files myhostname dns/' /etc/nsswitch.conf
getent hosts "$(hostname -s).${search}" || echo "warning: own record not found yet (expected on a template)"
