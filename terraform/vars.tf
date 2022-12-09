# credential proxmox
variable "proxmox_credentials" {
    type = map
    default = {
        proxmox_api_url = ""  # Your Proxmox IP Address
        proxmox_api_token_id = ""  # API Token ID
        proxmox_api_token_secret = "" # secret

    }
}

# pve name
variable "target_node" {
    default = "proxmox139"
    #ex
    #default = "proxmox31"
}

# vm name
variable "vm_name" {
    default = "test"
}

# template name for clone vm
variable "template_name" {
    default = "ubuntu-2004-cloudinit-template"
}

# username & password server
variable "svr_username" {
    default = "test1"
}

variable "svr_password" {
  default = "test1"
}
