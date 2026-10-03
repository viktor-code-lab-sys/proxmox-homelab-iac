output "reservation_count" {
  description = "Number of DHCP reservations under management."
  value       = length(var.reservations)
}

output "dns_entry_count" {
  description = "Number of DNS records under management."
  value       = length(var.dns_entries)
}
