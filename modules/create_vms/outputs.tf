output "vm_ipv4" {
  value = { for name, vm in proxmox_virtual_environment_vm.ubuntu_vm : name => try(vm.ipv4_addresses[0], null) }
}

output "vm_disk_debug" {
  value = {
    for name, vm in var.vms : name => {
      node_name        = vm.node_name
      vm_id            = vm.vm_id
      disk_datastore   = coalesce(try(vm.datastore_vm, null), var.datastore_vm)
      image_file_id    = proxmox_virtual_environment_download_file.ubuntu_cloud_image[vm.node_name].id
      init_datastore   = coalesce(try(vm.datastore_vm, null), var.datastore_vm)
      user_data_file   = proxmox_virtual_environment_file.user_data[vm.node_name].id
    }
  }
}