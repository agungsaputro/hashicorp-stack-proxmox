# Proxmox
# -----
# Create a new VM from a clone template

resource "proxmox_vm_qemu" "svr-vm" {
    # count number
    count = 1

    # VM General Settings
    target_node = var.target_node
    vmid = "8310${count.index+1}"
    name = var.vm_name
    desc = "Description"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = var.template_name

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 1024

    # VM Disk
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    # VM Hard disk capacity
    disk{
       slot = 0
        # set disk size here. leave it small for testing because expanding the disk takes time.
        size = "10G"
        type = "scsi"
        storage = "hdd"
        # storage_type = "lvm"
        iothread = 1 
        backup = true
    }

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
        vlan = "35"
    }

    lifecycle {
        ignore_changes = [
        network,
        ]
    }
    

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # VM IP Address and Gateway
    ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
    
    # Default User & Password
    ciuser = var.svr_username
    cipassword = var.svr_password
  
}

