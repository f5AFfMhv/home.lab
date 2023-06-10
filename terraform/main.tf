resource "proxmox_vm_qemu" "vm" {
  count     = var.vm_count
  target_node = var.pve_node
  name      = "${var.vm_name[count.index]}"
  os_type   = "cloud-init"
  memory    = var.vm_memory
  cores     = var.vm_cpu
  sockets   = 1
  clone     = var.template_name
  agent     = 1
  bootdisk  = "scsi0"

  network {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  disk {
    storage = var.vm_storage
    size    = var.vm_disk
    type    = "scsi"
  }

  ipconfig0 = "ip=${var.vm_ip_addresses[count.index]}/24,gw=${var.vm_gateway}"

  sshkeys = "${file("~/.ssh/id_rsa.pub")}"

  connection {
    type = "ssh"
    host = "${var.vm_ip_addresses[count.index]}"
    user = "debian"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  # provisioner "local-exec" {
  #   command = "ssh-keygen -R ${var.vm_ip_addresses[count.index]} && ssh-keyscan -t ecdsa ${var.vm_ip_addresses[count.index]} >> ~/.ssh/known_hosts"
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update"
    ]
  }

}