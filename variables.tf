variable "endpoint" {
  description = "Proxmox API endpoint (https://host:8006/)"
  type        = string
}

# ansible@pve!ansible=9f290045-6c00-4912-ae1d-cc9184c57c6b
variable "api_token" {
  description = "Proxmox API token in full form: user@realm!token=<uuid>"
  type        = string
  sensitive   = true
}

variable "insecure" {
  description = "Allow insecure TLS"
  type        = bool
  default     = true
}

# Image settings
variable "image_url" {
  description = "Cloud image URL"
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "image_file_name" {
  description = "Filename to store the downloaded image as"
  type        = string
  default     = "ubuntu-24.04-noble.img"
}

# Storage/bridge defaults
variable "datastore_image" {
  type    = string
  default = "local"
}

variable "datastore_vm" {
  type    = string
  default = "local-lvm"
}

variable "default_bridge" {
  type    = string
  default = "vmbr0"
}

# Cloud-init defaults
variable "ci_username" {
  type    = string
  default = "psubedi"
}

variable "ssh_authorized_key_path" {
  description = "Path to a public key to inject; leave empty to skip"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# One VM per entry (key = VM name)
variable "vms" {
  description = "Map of per-VM configs"
  type = map(object({
    node_name = string
    vm_id     = number
    cores     = number
    memory_mb = number
    disk_gb   = number
    bridge    = optional(string)
    ip_cidr   = optional(string) # "dhcp" or "x.x.x.x/nn"
    gateway   = optional(string)
    datastore = optional(string) # override for boot disk
  }))
}
