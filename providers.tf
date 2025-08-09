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
}
