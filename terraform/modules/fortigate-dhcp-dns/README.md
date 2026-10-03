# Module: fortigate-dhcp-dns

Adds a DHCP reservation and a DNS A record per VM on a FortiGate
(fortinetdev/fortios provider) without taking ownership away from records that
were created by hand.

## Adopting an existing firewall

1. Import both objects:
   ```bash
   terraform import 'module.network.fortios_systemdhcp_server.this' <dhcp_server_id>
   terraform import 'module.network.fortios_system_dnsdatabase.this' <zone_name>
   ```
2. Export what already exists into the legacy variables:
   ```bash
   terraform show -json > state.json
   jq '[.values.root_module.child_modules[].resources[]
        | select(.type=="fortios_system_dnsdatabase") | .values.dns_entry[]
        | {hostname, ip, type, status}]' state.json
   ```
3. `terraform plan` must show `0 to add, 0 to destroy` before the first apply.

Keep the exported legacy lists in a private `*.auto.tfvars` file; they describe the
whole home network and do not belong in a public repository.

## Provider aliases

DHCP and DNS can live in different VDOMs, so the module takes two providers:

```hcl
module "network" {
  source    = "../../modules/fortigate-dhcp-dns"
  providers = { fortios.dhcp = fortios.lab_vdom, fortios.dns = fortios.root_vdom }
  # ...
}
```
