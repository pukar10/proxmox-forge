# ==== Proxmox connection ====
variable "endpoint" {
  description = "Proxmox API endpoint (https://host:8006/)"
  type        = string
}

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

# ==== SSH connection to Proxmox host ====
variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_use_agent" {
  type    = bool
  default = true
}

variable "ssh_password" {
  type      = string
  default   = ""
  sensitive = true
}

# ==== VM creation ====
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

# ---- Cloud-init user ----
variable "ci_username" {
  description = "Username for the cloud-init user"
  type        = string
}

variable "ci_password" {
  description = "Password for cloud-init user"
  type        = string
  sensitive   = true
}

variable "ci_ssh_key" {
  description = "Path to a public key to inject"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
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
