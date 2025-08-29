module "create_vms" {
  source = "./modules/create_vms"

  image_url       = var.image_url
  image_file_name = var.image_file_name
  datastore_image = var.datastore_image
  datastore_vm    = var.datastore_vm
  default_bridge  = var.default_bridge

  ci_username = var.ci_username
  ci_password = var.ci_password
  ci_pubkey   = file(pathexpand("~/.ssh/id_ed25519.pub"))

  vms = var.vms

}
