
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.6"
    }
  }
}
provider "proxmox" {
    pm_api_url = "https://192.168.1.99:8006/api2/json"
    pm_user = "root@pam"
    pm_password = "27942794"
    pm_tls_insecure = "true"
}
resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = 1
  name              = "tf-vm"
  target_node       = "pve"
  clone             = "deploy"
  os_type           = "cloud-init"
  cores             = "1"
  sockets           = "1"
  cpu               = "kvm64"
  memory            = 3072
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "virtio0"
  hotplug = "network,disk,usb"
   disk {
        size = "10G"
        type = "virtio"
        storage = "local-lvm"
    }
ipconfig2 = "ip=192.168.1.114/24,gw=192.168.1.1"
 }
 
