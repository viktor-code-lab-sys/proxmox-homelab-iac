# Module: proxmox-vm

Full-clones a cloud-init template on Proxmox VE (bpg/proxmox provider) and attaches
a per-VM cloud-init snippet. The NIC gets a deterministic MAC so that the address
comes from a DHCP reservation instead of a static cloud-init IP.

## Requirements

- The provider's `ssh {}` block must be configured: snippets are uploaded over SSH.
- The Proxmox API token needs `Datastore.Allocate`, `Datastore.AllocateSpace` and
  `Datastore.Audit` on both datastores, plus `SDN.Use` on the VLAN zone if SDN is used.

## Usage

```hcl
module "vm" {
  source = "../../modules/proxmox-vm"

  name           = "app-01"
  vm_id          = 120
  node_name      = "pve"
  template_vm_id = 194
  datastore_id   = "datastore"
  vlan_id        = 104
  mac_address    = "BC:24:11:E0:00:12"
  user_data      = templatefile("cloud-init/vault-agent-userdata.yaml.tftpl", { secret_id = "..." })
}
```

Background: [provisioning flow](https://viktor-code-lab-sys.github.io/proxmox-homelab-case-study/architecture/provisioning-flow/).
