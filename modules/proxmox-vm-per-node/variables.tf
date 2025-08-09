variable "image_url" { type = string }
variable "image_file_name" { type = string }

variable "datastore_image" { type = string }
variable "datastore_vm" { type = string }
variable "default_bridge" { type = string }

variable "ci_username" { type = string }
variable "ssh_authorized_key_path" {
  type    = string
  default = ""
}

variable "ci_password" {
  description = "Optional password for the cloud-init user"
  type        = string
  sensitive   = true
  default     = ""
}

# cloud-init
variable "user_data_content" {
  description = "Optional cloud-init user-data; if empty, none is attached."
  type        = string
  default     = ""
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
