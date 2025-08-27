module "create_vms" {
  source = "./modules/create_vms"

  image_url               = var.image_url
  image_file_name         = var.image_file_name
  datastore_image         = var.datastore_image
  datastore_vm            = var.datastore_vm
  default_bridge          = var.default_bridge
  ci_username             = var.ci_username
  ci_password             = var.ci_password
  ssh_authorized_key_path = var.ssh_authorized_key_path
  user_data_content       = var.user_data_content
  vms                     = var.vms
}
