# Environment: example

Wires the three modules into the self-service flow: one map entry in `vms` produces a
VM, its DHCP reservation, its DNS record and a Vault secret_id delivered through
cloud-init.

```bash
cp terraform.tfvars.example terraform.tfvars
cp backend.tf.example backend.tf          # optional: GitLab-managed state
export TF_VAR_proxmox_api_token='user@pve!automation=...'
export TF_VAR_fortigate_api_token='...'
export VAULT_TOKEN='...'
terraform init
terraform plan
```

In the lab this directory is driven by Atlantis from merge requests; see `../../../atlantis`.
