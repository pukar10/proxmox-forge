output "vm_ipv4" {
  value = { for name, vm in proxmox_virtual_environment_vm.vm : name => try(vm.ipv4_addresses[0], null) }
}
