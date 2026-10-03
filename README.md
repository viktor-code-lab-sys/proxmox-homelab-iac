# proxmox-homelab-iac

[![CI](https://github.com/viktor-code-lab-sys/proxmox-homelab-iac/actions/workflows/ci.yml/badge.svg)](https://github.com/viktor-code-lab-sys/proxmox-homelab-iac/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Infrastructure as code for an air-gapped homelab platform on a single Proxmox VE host:
self-service VMs from a merge request, an end-to-end internal PKI, a Kubernetes cluster
built "the hard way", and the applications and monitoring that run on it.

**Case study, architecture and decision records:**
https://viktor-code-lab-sys.github.io/proxmox-homelab-case-study/

## What a merge request does

One entry in `vms` → `atlantis apply` → in about a minute:

1. a Vault AppRole `secret_id` is issued for the VM,
2. the VM is cloned from a template with that `secret_id` in its cloud-init,
3. the firewall gets a DHCP reservation and a DNS record for it,
4. on first boot the VM's Vault Agent fetches its own TLS certificate.

## Layout

| Path | Contents |
| --- | --- |
| `terraform/modules/proxmox-vm` | VM from a cloud-init template + per-VM snippet |
| `terraform/modules/fortigate-dhcp-dns` | DHCP reservation + DNS record next to hand-made ones |
| `terraform/modules/vault-approle-secret` | one AppRole secret_id per VM |
| `terraform/environments/example` | the three modules wired together |
| `atlantis/` | repo and server config, secrets helper, container run |
| `kubernetes/platform` | ingress-nginx, local-path, cert-manager + Vault issuer |
| `kubernetes/apps` | Nextcloud and Guacamole in isolated namespaces |
| `kubernetes/monitoring` | kube-prometheus-stack values for an air-gapped registry |
| `jenkins/` | idempotent node_exporter rollout over SSH |
| `templates/` | scripts baked into the VM templates (DNS fix, Vault Agent) |
| `supply-chain/` | mirror scripts: the only path from the internet into the lab |

## Stack

Proxmox VE · Terraform (bpg/proxmox, fortinetdev/fortios, hashicorp/vault) · Atlantis ·
GitLab · HashiCorp Vault PKI · Kubernetes 1.31 (the hard way) · Calico · ingress-nginx ·
cert-manager · Harbor + ORAS · Prometheus/Grafana · Jenkins · FortiGate

## Conventions

All names and addresses are placeholders: domain `homelab.example`, lab subnet
`10.0.104.0/24`, registry `registry.homelab.example`. Secrets are never committed;
they come from Vault or from environment variables.

## License

[MIT](LICENSE). The documentation site is published separately under CC BY 4.0.
