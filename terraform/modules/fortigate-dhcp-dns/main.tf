# Both objects already exist on the firewall and are shared with devices that are
# not managed here. Import them first, then pass every existing entry back in via
# the legacy lists; otherwise the first apply deletes them.

resource "fortios_systemdhcp_server" "this" {
  provider = fortios.dhcp

  fosid                 = var.dhcp_server_id
  interface             = var.dhcp_interface
  domain                = var.domain
  default_gateway       = var.default_gateway
  netmask               = var.netmask
  dns_server1           = var.dns_server
  dynamic_sort_subtable = "false"
  get_all_tables        = "false"

  ip_range {
    start_ip = var.ip_range_start
    end_ip   = var.ip_range_end
  }

  dynamic "reserved_address" {
    for_each = var.reservations
    content {
      ip          = reserved_address.value.ip
      mac         = reserved_address.value.mac
      action      = "reserved"
      description = reserved_address.value.description
    }
  }
}

resource "fortios_system_dnsdatabase" "this" {
  provider = fortios.dns

  name                  = var.dns_zone_name
  domain                = var.domain
  type                  = "primary" # the API name; the CLI calls it "master"
  authoritative         = "disable"
  ttl                   = var.dns_zone_ttl
  view                  = var.dns_view
  dynamic_sort_subtable = "false"
  get_all_tables        = "false"

  dynamic "dns_entry" {
    for_each = var.dns_entries
    content {
      hostname = dns_entry.value.hostname
      ip       = dns_entry.value.ip
      type     = dns_entry.value.type
      status   = dns_entry.value.status
    }
  }
}
