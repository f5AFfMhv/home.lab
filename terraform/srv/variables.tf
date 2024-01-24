variable "pve_node" {
  default     = "srv"
  description = "PVE node name"
}

variable "pve_host" {
  default     = "srv.home.lab"
  description = "PVE server hostname or ip"
}

variable "template_name" {
  default     = "Debian12CloudInit"
  description = "CloudInit vm template name"
}

variable "vm_count" {
  default     = 1
  description = "Number of VMs to create"
}

variable "vm_name" {
  default     = ["docker"]
  description = "VM name"
}

variable "vm_cpu" {
  default     = [4]
  description = "VM cpu cores"
}

variable "vm_storage" {
  default     = "ZFS-mirror"
  description = "VM storage name"
}

variable "vm_disk" {
  default     = ["40G"]
  description = "VM disk size"
}

variable "vm_memory" {
  default     = [10240]
  description = "VM memory in MB"
}

variable "vm_ip_addresses" {
  default     = ["192.168.1.13"]
  description = "VM ip address"
}

variable "vm_gateway" {
  default     = "192.168.1.1"
  description = "Gateway"
}
