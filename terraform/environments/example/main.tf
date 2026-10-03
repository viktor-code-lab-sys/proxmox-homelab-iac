locals {
  # Address and MAC are both derived from host_index, so a VM's DHCP reservation,
  # DNS record and NIC always agree. HCL has no hex literals: 0xE0 is written as 224.
  vms = {
    for name, vm in var.vms : name => merge(vm, {
      ip   = cidrhost(var.subnet_cidr, vm.host_index)
      mac  = format("BC:24:11:%02X:%02X:%02X", 224, floor(vm.host_index / 256), vm.host_index % 256)
      fqdn = "${name}.${var.domain}"
    })
  }
}

module "vm_secret" {
  source   = "../../modules/vault-approle-secret"
  for_each = local.vms

  role_name = var.vault_approle_role
  cidr_list = [var.subnet_cidr]
  metadata  = { vm = each.key }
}

module "vm" {
  source   = "../../modules/proxmox-vm"
  for_each = local.vms

  name           = each.key
  vm_id          = each.value.vmid
  node_name      = var.proxmox_node_name
  template_vm_id = var.template_vm_id
  cores          = each.value.cores
  memory_mb      = each.value.memory_mb
  disk_gb        = each.value.disk_gb
  datastore_id   = var.datastore_id
  bridge         = var.bridge
  vlan_id        = var.vlan_id
  mac_address    = each.value.mac

  user_data = templatefile("${path.module}/cloud-init/vault-agent-userdata.yaml.tftpl", {
    secret_id = module.vm_secret[each.key].secret_id
  })
}

module "network" {
  source = "../../modules/fortigate-dhcp-dns"
  providers = {
    fortios.dhcp = fortios.lab_vdom
    fortios.dns  = fortios.root_vdom
  }

  dhcp_server_id  = var.dhcp_server_id
  dhcp_interface  = var.dhcp_interface
  domain          = var.domain
  default_gateway = cidrhost(var.subnet_cidr, 1)
  netmask         = cidrnetmask(var.subnet_cidr)
  dns_server      = var.dns_server
  ip_range_start  = var.dhcp_range.start
  ip_range_end    = var.dhcp_range.end
  dns_zone_name   = var.dns_zone_name

  reservations = concat(var.legacy_reservations, [
    for name, vm in local.vms : { ip = vm.ip, mac = vm.mac, description = name }
  ])

  dns_entries = concat(var.legacy_dns_entries, [
    for name, vm in local.vms : { hostname = name, ip = vm.ip, type = "A", status = "enable" }
  ])
}
