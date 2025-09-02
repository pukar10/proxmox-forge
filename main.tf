# locals {
#   cloud_init_rendered = templatefile("${path.module}/templates/cloud-init.yaml", {
#     username = var.ci_username
#     password = var.ci_password
#     pubkey   = chomp(file(pathexpand("~/.ssh/id_ed25519.pub")))
#   })
# }

module "create_vms" {
  source = "./modules/create_vms"

  image_url       = var.image_url
  image_file_name = var.image_file_name
  datastore_image = var.datastore_image
  datastore_vm    = var.datastore_vm
  default_bridge  = var.default_bridge

  ci_username = var.ci_username
  ci_password = var.ci_password
  cci_ssh_key = var.ci_ssh_key

  # cloud_init = local.cloud_init_rendered

  vms = var.vms

}
