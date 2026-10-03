variable "role_name" {
  description = "AppRole role the secret_id is generated for (scoped to pki/issue only)."
  type        = string
}

variable "backend" {
  description = "Mount path of the AppRole auth method."
  type        = string
  default     = "approle"
}

variable "cidr_list" {
  description = "CIDRs allowed to use this secret_id. Empty list = inherit the role binding."
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Key/value metadata stored with the secret_id (e.g. the VM name) for auditing."
  type        = map(string)
  default     = {}
}
