locals {
  ssh_key = var.ssh_authorized_key_path != "" ? trimspace(file(var.ssh_authorized_key_path)) : null
  nodes   = toset([for vm in values(var.vms) : vm.node_name])
}

# Download the cloud image to each referenced node once
resource "proxmox_virtual_environment_download_file" "cloud_image" {
  for_each     = local.nodes
  content_type = "iso"
  datastore_id = var.datastore_image
  node_name    = each.value
  url          = var.image_url
  file_name    = var.image_file_name
}

# Create one VM per map entry
resource "proxmox_virtual_environment_vm" "vm" {
  for_each   = var.vms

  name      = each.key
  node_name = each.value.node_name
  vm_id     = each.value.vm_id
  tags      = concat(["terraform"], coalesce(each.value.tags, []))

  started = true
  on_boot = true

  agent { enabled = true }

  # Helpful with some cloud images when resizing
  serial_device { device = "socket" }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory { dedicated = each.value.memory_mb }

  operating_system { type = "l26" }

  disk {
    datastore_id = coalesce(each.value.datastore, var.datastore_vm)
    file_id      = proxmox_virtual_environment_download_file.cloud_image[each.value.node_name].id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = each.value.disk_gb
  }

  network_device {
    bridge   = coalesce(each.value.bridge, var.default_bridge)
    model    = "virtio"
    vlan_tag = try(each.value.vlan, 0) # 0 = no VLAN
  }

  initialization {
    datastore_id = var.datastore_vm

    user_account {
      username = var.ci_username
      keys     = local.ssh_key != null ? [local.ssh_key] : null
    }

    ip_config {
      ipv4 {
        address = try(each.value.ip_cidr, "dhcp")
        gateway = try(each.value.gateway4, null)
      }
    }
  }
}
