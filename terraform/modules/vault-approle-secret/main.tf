# One secret_id per VM. The role must allow unlimited uses (secret_id_num_uses = 0):
# with a single use, Terraform's own refresh consumes it before the VM boots.
resource "vault_approle_auth_backend_role_secret_id" "this" {
  backend   = var.backend
  role_name = var.role_name
  cidr_list = var.cidr_list
  metadata  = jsonencode(var.metadata)
}
