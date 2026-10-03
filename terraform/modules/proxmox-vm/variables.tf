variable "name" {
  description = "VM name; also used as the hostname and the cloud-init snippet file name."
  type        = string
}

variable "vm_id" {
  description = "Proxmox VMID for the new VM."
  type        = number
}

variable "node_name" {
  description = "Proxmox node that hosts the VM and the cloud-init snippet."
  type        = string
}

variable "template_vm_id" {
  description = "VMID of the cloud-init template to full-clone (the Vault Agent template)."
  type        = number
}

variable "cores" {
  description = "Number of vCPU cores."
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Dedicated memory in MiB."
  type        = number
  default     = 2048
}

variable "disk_gb" {
  description = "Size of the system disk in GiB."
  type        = number
  default     = 30
}

variable "datastore_id" {
  description = "Datastore for the system disk and the cloud-init drive."
  type        = string
}

variable "snippets_datastore_id" {
  description = "Datastore with the 'snippets' content type enabled (uploaded over SSH by the provider)."
  type        = string
  default     = "local"
}

variable "bridge" {
  description = "Linux bridge the VM NIC is attached to."
  type        = string
  default     = "vmbr1"
}

variable "vlan_id" {
  description = "VLAN tag for the VM NIC."
  type        = number
}

variable "mac_address" {
  description = "Deterministic MAC address; must match the DHCP reservation."
  type        = string
}

variable "user_data" {
  description = "Rendered cloud-init user-data. Contains the Vault secret_id, so it is sensitive."
  type        = string
  sensitive   = true
}
