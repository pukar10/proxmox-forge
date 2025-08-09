module "proxmox_vm_per_node" {
  source = "./modules/proxmox-vm-per-node"

  image_url             = var.image_url
  image_file_name       = var.image_file_name
  datastore_image       = var.datastore_image
  datastore_vm          = var.datastore_vm
  default_bridge        = var.default_bridge
  ci_username           = var.ci_username
  ssh_authorized_key_path = var.ssh_authorized_key_path
  vms                   = var.vms
}
