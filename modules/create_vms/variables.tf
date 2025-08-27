variable "image_url" { type = string }
variable "image_file_name" { type = string }

variable "datastore_image" { type = string }
variable "datastore_vm" { type = string }
variable "default_bridge" { type = string }

variable "ssh_authorized_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

# cloud-init
variable "user_data_content" {
  description = "Optional cloud-init user-data; if empty, none is attached."
  type        = string
  sensitive   = true
}

variable "vms" {
  type = map(object({
    node_name = string
    vm_id     = number
    cores     = number
    memory_mb = number
    disk_gb   = number
    bridge    = optional(string)
    ip_cidr   = optional(string)
    gateway   = optional(string)
    datastore = optional(string)
  }))
}
