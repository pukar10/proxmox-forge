output "vm_ipv4" {
  description = "First IPv4 reported by guest agent per VM"
  value       = module.create_vms.vm_ipv4
}
