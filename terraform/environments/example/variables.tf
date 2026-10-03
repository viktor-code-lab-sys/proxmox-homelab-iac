# --- Proxmox -----------------------------------------------------------------

variable "proxmox_endpoint" {
  description = "Proxmox API URL, e.g. https://pve.homelab.example:8006."
  type        = string
}

variable "proxmox_api_token" {
  description = "API token in the form 'user@realm!tokenid=uuid'. Pass via TF_VAR_proxmox_api_token."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification of the Proxmox API (only if its certificate lacks the right SAN)."
  type        = bool
  default     = false
}

variable "proxmox_ssh_username" {
  description = "SSH user for snippet uploads."
  type        = string
  default     = "root"
}

variable "proxmox_ssh_private_key_path" {
  description = "Path to the SSH private key used for snippet uploads."
  type        = string
}

variable "proxmox_node_name" {
  description = "Proxmox node name."
  type        = string
}

variable "proxmox_node_address" {
  description = "IP or FQDN the provider uses to SSH into the node."
  type        = string
}

variable "template_vm_id" {
  description = "VMID of the Vault Agent cloud-init template."
  type        = number
}

variable "datastore_id" {
  description = "Datastore for VM disks and cloud-init drives."
  type        = string
}

variable "bridge" {
  description = "Bridge the VM NICs attach to."
  type        = string
  default     = "vmbr1"
}

variable "vlan_id" {
  description = "VLAN tag of the lab network."
  type        = number
}

# --- FortiGate ---------------------------------------------------------------

variable "fortigate_hostname" {
  description = "FortiGate admin endpoint including the port, e.g. fw.homelab.example:14443."
  type        = string
}

variable "fortigate_api_token" {
  description = "REST API token of the restricted API user. Pass via TF_VAR_fortigate_api_token."
  type        = string
  sensitive   = true
}

variable "fortigate_ca_bundle_path" {
  description = "PEM bundle (intermediate + root) that signed the FortiGate admin certificate."
  type        = string
}

variable "fortigate_dns_vdom" {
  description = "VDOM that holds the DNS database."
  type        = string
  default     = "root"
}

variable "fortigate_dhcp_vdom" {
  description = "VDOM that holds the lab DHCP server."
  type        = string
}

variable "dhcp_server_id" {
  description = "fosid of the lab DHCP server."
  type        = number
}

variable "dhcp_interface" {
  description = "Interface of the lab DHCP server."
  type        = string
}

variable "dhcp_range" {
  description = "Dynamic pool of the lab DHCP server."
  type = object({
    start = string
    end   = string
  })
}

variable "dns_zone_name" {
  description = "Name of the DNS database object on the FortiGate."
  type        = string
}

# --- Network & naming --------------------------------------------------------

variable "domain" {
  description = "Internal DNS domain."
  type        = string
}

variable "subnet_cidr" {
  description = "Lab subnet; VM addresses are derived from it with cidrhost()."
  type        = string
}

variable "dns_server" {
  description = "Internal DNS resolver handed out by DHCP."
  type        = string
}

variable "legacy_reservations" {
  description = "DHCP reservations that existed before Terraform. Keep the real list in a private *.auto.tfvars."
  type = list(object({
    ip          = string
    mac         = string
    description = string
  }))
  default = []
}

variable "legacy_dns_entries" {
  description = "DNS records that existed before Terraform. Keep the real list in a private *.auto.tfvars."
  type = list(object({
    hostname = string
    ip       = string
    type     = optional(string, "A")
    status   = optional(string, "enable")
  }))
  default = []
}

# --- Vault -------------------------------------------------------------------

variable "vault_addr" {
  description = "Vault API address."
  type        = string
}

variable "vault_approle_role" {
  description = "AppRole role whose secret_id is delivered to new VMs."
  type        = string
  default     = "vm-cert-issuer"
}

# --- VMs ---------------------------------------------------------------------

variable "vms" {
  description = "VMs to create. host_index is the host part of the address inside subnet_cidr."
  type = map(object({
    vmid       = number
    host_index = number
    cores      = optional(number, 2)
    memory_mb  = optional(number, 2048)
    disk_gb    = optional(number, 30)
  }))
  default = {}
}
