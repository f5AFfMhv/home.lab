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
  default     = 6
  description = "Number of VMs to create"
}

variable "vm_name" {
  default     = ["k3s-cp", "k3s-w1", "k3s-w2", "docker", "k8s-cp", "k8s-w1"]
  description = "VM name"
}

variable "vm_cpu" {
  default     = [2, 2, 2, 4, 2, 2]
  description = "VM cpu cores"
}

variable "vm_storage" {
  default     = "local-lvm"
  description = "VM storage name"
}

variable "vm_disk" {
  default     = ["10G", "10G", "10G", "20G", "10G", "10G"]
  description = "VM disk size"
}

variable "vm_memory" {
  default     = [2048, 2048, 2048, 4096, 2048, 2048]
  description = "VM memory in MB"
}

variable "vm_ip_addresses" {
  default     = ["192.168.1.30", "192.168.1.31", "192.168.1.32", "192.168.1.34", "192.168.1.37", "192.168.1.38"]
  description = "VM ip address"
}

variable "vm_gateway" {
  default     = "192.168.1.1"
  description = "Gateway"
}
