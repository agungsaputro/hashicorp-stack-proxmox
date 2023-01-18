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
    default = ""
    #ex
    #default = "proxmox31"
}

# vm name
variable "vm_name" {
    default = "" #ex default = "vm-1"
}

# template name for clone vm
variable "template_name" {
    default = "" #ex default = "ubuntu-template"
}

# cores
variable "cores" {
    default = "" #ex  default = "1"
}

# sockets
variable "sockets" {
    default = "" #ex default = "1" 
}

#memory
variable "memory" {
    default = "" #ex default = "1024"
}

# disk
variable "svr_disk" {
    type = map
    default = {
        size    = "" #ex size    = "10G"
        type    = "" #ex type    = "scsi"
        storage = ""  #ex storage = "hdd"
    }
}

# network
variable "svr_network" {
    type = map
    default = {
        bridge = "" #ex bridge = "vmbr4"
        model  = "" #ex model  = "virtio"
        tag    = "" #ex tag    = "35"
    }
}

# ip for vm setup
variable "svr_ip" {
  default = "" #ex default = "10.10.10.10"
}

# network gateway for vm setup
variable "svr_gw" {
  default = "" #ex default = "10.10.10.1"
}

# nameserver setup for vm

variable "svr_nameservers" {
  default = "" #ex default = "1.1.1.1 8.8.8.8"
}

# username & password server
variable "svr_username" {
    default = "" #ex default = "vm"
}

variable "svr_password" {
  default = "" #ex  default = "password"
}

# ssh_keys
variable "ssh_key_path" {
  type = map
  default = {
    pub  = "~/.ssh/id_rsa.pub"
    priv = "~/.ssh/id_rsa"
  }
}
