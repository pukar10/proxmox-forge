variable "image_url"       { type = string }
variable "image_file_name" { type = string }

variable "datastore_image" { type = string }
variable "datastore_vm"    { type = string }
variable "default_bridge"  { type = string }

variable "ci_username" { type = string }
variable "ssh_authorized_key_path" {
  type    = string
  default = ""
}

variable "vms" {
  type = map(object({
    node_name  = string
    vm_id      = number
    cores      = number
    memory_mb  = number
    disk_gb    = number
    bridge     = optional(string)
    vlan       = optional(number)
    ip_cidr    = optional(string)
    gateway4   = optional(string)
    tags       = optional(list(string))
    datastore  = optional(string)
  }))
}
