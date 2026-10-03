terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.19"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.12"
    }
  }
}
