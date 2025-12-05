# Base configuration variables
variable "hostname" {
  description = "VM hostname"
  default = "mail-test-01"
}

variable "ip_address" {
  description = "IPv4 address"
  default = "192.168.10.77/24"
}

variable "ip_gateway" {
  description = "IPv4 default gateway"
  default = "192.168.10.1"
}

variable "ip6_address" {
  description = "IPv4 address"
  default = "2a01:4f8:231:aa6::77/120"
}

variable "ip6_gateway" {
  description = "IPv6 default gateway"
  default = "2a01:4f8:231:aa6::1"
}

variable "dns_address1" {
  description = "Serveur DNS 1"
  type        = string
  default     = "213.133.99.99"
}

variable "dns_address2" {
  description = "Serveur DNS 2"
  type        = string
  default     = "213.133.100.100"
}

variable "dns_address3" {
  description = "Serveur DNS 3"
  type        = string
  default     = "213.133.98.98"
}

variable "ssh_public_key" {
  description = "Trusty SSH public key"
  default = default = file("/root/.ssh/id_rsa.pub")
  type = string
}

variable "appzer0_public_key" {
  description = "appzer0 Trusty SSH public key"
  default = file("/home/appzer0/.ssh/id_rsa.pub")
  type = string
}
  
# A local resource volume, raw format is needed on our ZFS filesystem.
# Note that libvirt provider needs us to put two resources as we need
# bigger space than the one from the raw image provided by Debian.

# OS volume, defaults to 10GB
variable "diskSize" { default = 1024*1024*1024*10 }

# Requires libvirt provider
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

# Local libvirt KVM host
provider "libvirt" {
  uri = "qemu:///system"
}

# Debian 12 Cloud image from Debian, from our "ISO" pool
resource "libvirt_volume" "base-debian12-raw" {
  provider = libvirt
  name = "base-debian12-raw"
  pool = "ISO"
  source = "https://cloud.debian.org/images/cloud/bookworm-backports/latest/debian-12-backports-genericcloud-amd64.raw"
}

# 10GB OS volume in our prod pool, based on our Debian 12
# Cloud image from ISO pool
resource "libvirt_volume" "debian12-raw" {
  provider = libvirt
  name = "debian12-raw.img"
  pool = "pool"
  size = var.diskSize
  # Volume is based on our Debian 12 Cloud image:
  base_volume_id = libvirt_volume.base-debian12-raw.id
}

# cloud-init templating to pass TF variables into it
# cloud-init settings (passwords, ssh keys)
data template_file "user_data" {
  template = file("${path.module}/cloud_init.cfg")

  vars = {
    ssh_public_key = var.ssh_public_key
    appzer0_public_key = var.appzer0_public_key
    hostname = var.hostname
  }
}

# cloud-init settings (network-related)
data template_file "network_config" {
  template = file("${path.module}/network_config.cfg")

  vars = {
      ipv4_address   = var.ip_address
      ipv6_address   = var.ip6_address
      ipv4_gw        = var.ip_gateway
      ipv6_gw        = var.ip6_gateway
      dns_address1   = var.dns_address1
      dns_address2   = var.dns_address2
      dns_address3   = var.dns_address3
  }
}

# the cloud-init actual resource
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

# Actual VM settings
resource "libvirt_domain" "vm" {
  name = var.hostname
  memory = "2048"
  vcpu   = 2
  autostart = true
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  
  # Basic network settings (cloud-init will take care of the rest)
  network_interface {
    bridge = "br2"
    wait_for_lease = false
  }
  
  # Root disk parameters
  disk {
    volume_id = libvirt_volume.debian12-raw.id
  }
  
  # The default method to boot
  boot_device {
    dev = [ "hd" ]
  }

  # PTYs
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  
  # video driver
  video {
    type = "virtio"
  }
  
  # Graphics
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

