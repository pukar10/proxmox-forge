locals {
  nodes = toset([for vm in values(var.vms) : vm.node_name])
}

# Create a cloud-init snippet per node
resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = local.nodes

  content_type = "snippets"
  datastore_id = var.datastore_image
  node_name    = each.value

  source_raw {
    file_name = "cloud-init-${each.value}.yaml"
    data = <<-EOF
      #cloud-config
      hostname: ${each.value}-vm
      timezone: America/New_York
      ssh_pwauth: true
      
      users:
        - defaut
        - name: ${var.ci_user}
          groups: 
            - sudo
          shell: /bin/bash
          ssh_authorized_keys:
            - ${var.ci_ssh_key}
          sudo: ALL=(ALL) NOPASSWD:ALL
          lock_passwd: false

      chpasswd:
        list: |
          ${var.ci_user}:${var.ci_password}
        expire: False

      package_update: true
      package_upgrade: true
      packages:
        - qemu-guest-agent
        - net-tools
        - curl
      
      runcmd:
        -- systemctl enable --now qemu-guest-agent
        - echo "done" > /tmp/cloud-config.done
      EOF
}

# Create VMs
resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  for_each = var.vms

  name      = each.key
  node_name = each.value.node_name
  vm_id     = each.value.vm_id

  started = true
  on_boot = true

  agent {
    enabled = true
    type    = "virtio"
    timeout = "20s"
  }
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
    datastore_id = each.value.datastore
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[each.value.node_name].id
    interface    = "virtio0"
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
    type         = "nocloud"
    datastore_id = var.datastore_vm

    user_data_file_id = proxmox_virtual_environment_file.cloud_init[each.value.node_name].id

    ip_config {
      ipv4 {
        address = each.value.ip_cidr
        gateway = each.value.gateway
      }
    }
  }

  depends_on = [
    proxmox_virtual_environment_download_file.ubuntu_cloud_image,
    proxmox_virtual_environment_file.cloud_init
  ]
}

# Download the cloud image to each referenced node
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  for_each     = local.nodes
  content_type = "iso"
  datastore_id = var.datastore_image
  node_name    = each.value
  url          = var.image_url
  file_name    = var.image_file_name
}
