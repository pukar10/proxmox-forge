module "create_vms" {
  source = "./modules/create_vms"

  image_url       = var.image_url
  image_file_name = var.image_file_name
  datastore_image = var.datastore_image
  datastore_vm    = var.datastore_vm
  default_bridge  = var.default_bridge
  user_data_content = templatefile("${path.module}/temlates/cloud-init.yaml.tmpl", {
    username = var.ci_username
    pubkey   = file("~/.ssh/id_ed25519.pub")
    password = var.ci_password
  })
  vms = var.vms
}
