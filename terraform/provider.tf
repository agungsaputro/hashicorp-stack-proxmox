# Proxmox Provider
# -------
# Initial Provider Terraform Configuration for Proxmox

terraform {
  required_providers{
    proxmox = {
        source = "telmate/proxmox",
        version = "2.9.10"
    }
  }
  required_version = ">= 0.13.0"
}

variable "proxmox_api_url" {
    type = string  
}

variable "proxmox_api_token_id" {
    type = string
  
}

variable "proxmox_api_token_secret" {
    type = string
  
}

provider "proxmox" {
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret

    #skip  tls verification (optional)
    pm_tls_insecure = true
  
}