# pve name
variable "target_node" {
    default = "your-proxmox-node"
    #ex
    #default = "proxmox31"
}

# vm name
variable "vm_name" {
    default = "your-vm-name"
}

# template name for clone vm
variable "template_name" {
    default = "your-template-name"
}

# username & password server
variable "svr_username" {
    default = "your-svr-username"
}

variable "svr_password" {
  default = "your-svr-password"
}
