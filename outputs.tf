output "vm_ipv4" {
  description = "First IPv4 reported by guest agent per VM"
  value       = module.proxmox_vm_per_node.vm_ipv4
}
