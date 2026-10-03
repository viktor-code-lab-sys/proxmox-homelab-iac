output "vm_id" {
  description = "Proxmox VMID of the created VM."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "Name of the created VM."
  value       = proxmox_virtual_environment_vm.this.name
}
