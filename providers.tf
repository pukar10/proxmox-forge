terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.70.0, < 1.0.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.endpoint
  insecure  = var.insecure
  api_token = var.api_token

  ssh {
    username    = var.ssh_username
    agent       = var.ssh_use_agent
    private_key = var.ssh_private_key_path != "" ? file(var.ssh_private_key_path) : null
    password    = var.ssh_password != "" ? var.ssh_password : null
  }
}


