terraform {
  required_version = ">= 1.6"
  required_providers {
    fortios = {
      source                = "fortinetdev/fortios"
      version               = ">= 1.19"
      configuration_aliases = [fortios.dhcp, fortios.dns]
    }
  }
}
