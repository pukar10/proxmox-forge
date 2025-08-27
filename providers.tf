terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint  = var.endpoint
  insecure  = var.insecure
  api_token = var.api_token

  ssh {
    username = var.ssh_username
    agent    = var.ssh_use_agent
    password = var.ssh_password != "" ? var.ssh_password : null
  }
}


