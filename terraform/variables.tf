variable "pve_node" {
  default     = "pve"
  description = "PVE node name"
}

variable "pve_host" {
  default     = "pve.home.lab"
  description = "PVE server hostname or ip"
}

variable "template_name" {
  default     = "Debian12-CI"
  description = "CloudInit vm template name"
}

variable "vm_count" {
  default     = 1
  description = "Number of VMs to create"
}

variable "vm_name" {
  default     = ["k3s-cp", "k3s-w1", "k3s-w2"]
  description = "VM name"
}

variable "vm_cpu" {
  default     = 2
  description = "VM cpu cores"
}

variable "vm_storage" {
  default     = "local-lvm"
  description = "VM storage name"
}

variable "vm_disk" {
  default     = "10G"
  description = "VM disk size"
}

variable "vm_memory" {
  default     = 2048
  description = "VM memory in MB"
}

variable "vm_ip_addresses" {
  default     = ["192.168.1.30", "192.168.1.31", "192.168.1.32"]
  description = "VM ip address"
}

variable "vm_gateway" {
  default     = "192.168.1.1"
  description = "Gateway"
}
