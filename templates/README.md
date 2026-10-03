# VM templates

Two cloud-init templates built from the official Debian 13 cloud image:

| Template | Purpose | Extra content |
| --- | --- | --- |
| base | manual clones | CA certificate, NTP, qemu-guest-agent, DNS fix |
| vault-agent | Terraform clones | base + Vault Agent (`vault-agent/`) |

Build pattern: clone the template to a temporary VM, boot it, apply the change, stop
it, convert to a template, delete the old one, clone back to the canonical VMID.
Proxmox cannot rename a VMID, and keeping the VMID fixed means nothing that clones
from it has to change.

```bash
./fix-dns.sh 10.0.0.53 homelab.example
./bash-prompt.sh
sudo install -m 0644 vault-agent/agent.hcl /etc/vault-agent/agent.hcl
sudo install -m 0644 vault-agent/vault-agent.service /etc/systemd/system/vault-agent.service
sudo install -m 0755 vault-agent/reload-services.sh /usr/local/bin/reload-services.sh
sudo systemctl enable vault-agent     # enable, do not start: it starts on the clones
```
