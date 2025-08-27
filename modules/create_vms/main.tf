locals {
  nodes   = toset([for vm in values(var.vms) : vm.node_name])
}

# Create a cloud-init snippet per node (only if user_data_content is set)
resource "proxmox_virtual_environment_file" "user_data" {
  for_each = local.nodes

  node_name    = each.value
  content_type = "snippets"
  datastore_id = var.datastore_image

  source_raw {
    file_name = "ci-user-data.yaml"
    data      = var.user_data_content
  }
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

# Create VMs
resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  name      = each.key
  node_name = each.value.node_name
  vm_id     = each.value.vm_id

  started = true
  on_boot = true

  agent { enabled = true }

  # Helpful with some cloud images when resizing
  serial_device {
    device = "socket"
  }

  cpu {
    type    = "host"
    sockets = try(each.value.sockets, 1)
    cores   = each.value.cores
    numa    = true
  }

  memory {
    dedicated = each.value.memory_mb
    floating  = 0
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = coalesce(each.value.datastore, var.datastore_vm)
    file_id      = proxmox_virtual_environment_download_file.cloud_image[each.value.node_name].id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = each.value.disk_gb
    cache        = "none"
    aio          = "native"
    replicate    = false
  }

  network_device {
    bridge = coalesce(each.value.bridge, var.default_bridge)
    model  = "virtio"
  }

  initialization {
    datastore_id = var.datastore_vm

    # Attach cloud-init
    user_data_file_id = var.user_data_content != "" ? "${var.datastore_image}:snippets/ci-user-data.yaml" : null

    # user_account {
    #   username = var.ci_username
    #   keys     = local.ssh_key != null ? [local.ssh_key] : null
    #   password = var.ci_password != "" ? var.ci_password : null
    # }

    ip_config {
      ipv4 {
        address = try(each.value.ip_cidr, "dhcp")
        gateway = try(each.value.gateway, null)
      }
    }
  }
}
