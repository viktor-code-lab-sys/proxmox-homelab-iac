variable "dhcp_server_id" {
  description = "ID (fosid) of the existing FortiGate DHCP server to manage."
  type        = number
}

variable "dhcp_interface" {
  description = "Interface the DHCP server is bound to."
  type        = string
}

variable "domain" {
  description = "DNS domain handed out by DHCP and served by the DNS zone."
  type        = string
}

variable "default_gateway" {
  description = "Default gateway handed out by DHCP."
  type        = string
}

variable "netmask" {
  description = "Netmask handed out by DHCP."
  type        = string
}

variable "dns_server" {
  description = "Primary DNS server handed out by DHCP."
  type        = string
}

variable "ip_range_start" {
  description = "First address of the dynamic pool."
  type        = string
}

variable "ip_range_end" {
  description = "Last address of the dynamic pool."
  type        = string
}

variable "reservations" {
  description = "All MAC-based reservations: imported legacy ones first, then managed VMs."
  type = list(object({
    ip          = string
    mac         = string
    description = string
  }))
  default = []
}

variable "dns_zone_name" {
  description = "Name of the existing DNS database (zone object) on the FortiGate."
  type        = string
}

variable "dns_zone_ttl" {
  description = "Default TTL of the zone in seconds."
  type        = number
  default     = 86400
}

variable "dns_view" {
  description = "Zone view: 'shadow' keeps internal records off the public-facing view."
  type        = string
  default     = "shadow"
}

variable "dns_entries" {
  description = "All DNS records: imported legacy ones first, then managed VMs."
  type = list(object({
    hostname = string
    ip       = string
    type     = optional(string, "A")
    status   = optional(string, "enable")
  }))
  default = []
}
