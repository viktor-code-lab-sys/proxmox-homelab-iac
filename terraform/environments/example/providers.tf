provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure

  # Cloud-init snippets are uploaded over SSH, not through the API.
  ssh {
    username    = var.proxmox_ssh_username
    private_key = file(var.proxmox_ssh_private_key_path)

    # Explicit address: the node name may not resolve from inside the Atlantis container.
    node {
      name    = var.proxmox_node_name
      address = var.proxmox_node_address
    }
  }
}

# The FortiOS provider has no port argument: the admin port goes into the hostname.
provider "fortios" {
  alias        = "root_vdom"
  hostname     = var.fortigate_hostname
  token        = var.fortigate_api_token
  vdom         = var.fortigate_dns_vdom
  cabundlefile = var.fortigate_ca_bundle_path
}

provider "fortios" {
  alias        = "lab_vdom"
  hostname     = var.fortigate_hostname
  token        = var.fortigate_api_token
  vdom         = var.fortigate_dhcp_vdom
  cabundlefile = var.fortigate_ca_bundle_path
}

# Token comes from VAULT_TOKEN in the environment.
provider "vault" {
  address = var.vault_addr
}
