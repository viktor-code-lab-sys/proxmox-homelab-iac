# Module: vault-approle-secret

Issues an AppRole `secret_id` for one VM. The VM's Vault Agent reads it from a file
written by cloud-init, logs in, and fetches its own TLS certificate.

Role settings that make this reliable:

| Setting | Value | Why |
| --- | --- | --- |
| `secret_id_num_uses` | `0` | `terraform refresh` would otherwise consume the only use |
| `secret_id_ttl` | hours, not minutes | plan and apply can be far apart in a merge request |
| `secret_id_bound_cidrs` | the lab subnet | a leaked secret_id is useless elsewhere |
| policy | `pki/issue/<role>` only | nothing else is reachable with this token |

Known quirk: destroying a secret_id that already expired returns an error. Remove it
from state with `terraform state rm`; the VM itself is unaffected.
