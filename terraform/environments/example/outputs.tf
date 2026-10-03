output "vms" {
  description = "Created VMs with their derived address and FQDN."
  value = {
    for name, vm in local.vms : name => {
      vm_id = module.vm[name].vm_id
      ip    = vm.ip
      fqdn  = vm.fqdn
    }
  }
}
