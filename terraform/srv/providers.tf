terraform {
  required_providers {
    # Broken since v8.0.4, see https://github.com/Telmate/terraform-provider-proxmox/issues/863
    # proxmox = {
    #   source = "telmate/proxmox"
    #   version = "2.9.14"
    # }
    proxmox = {
      source  = "thegameprofi/proxmox"
      version = ">= 2.9.15"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.pve_host}:8006/api2/json"
  pm_tls_insecure = true
}
