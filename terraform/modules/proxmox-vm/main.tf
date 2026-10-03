# Per-VM cloud-init snippet. It carries the Vault AppRole secret_id that the
# Vault Agent baked into the template uses on first boot to fetch its TLS cert.
resource "proxmox_virtual_environment_file" "user_data" {
  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.node_name

  source_raw {
    file_name = "${var.name}-userdata.yaml"
    data      = var.user_data
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    interface    = "scsi0"
    size         = var.disk_gb
    datastore_id = var.datastore_id
  }

  network_device {
    bridge      = var.bridge
    vlan_id     = var.vlan_id
    mac_address = var.mac_address
  }

  # The address itself comes from a DHCP reservation keyed by the MAC above.
  initialization {
    datastore_id      = var.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.user_data.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
