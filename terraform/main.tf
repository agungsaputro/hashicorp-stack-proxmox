# Proxmox
# -----
# Create a new VM from a clone template

resource "proxmox_vm_qemu" "svr_test1" {
    # count number
    count = 1

    # VM General Settings
    target_node = var.target_node
    vmid = "100${count.index+1}"
    name = var.vm_name
    desc = "Description: ini vm os ubuntu 22.04 yang di otomasi dengan terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = var.template_name

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = var.cores
    sockets = var.sockets
    cpu = "host"    
    
    # VM Memory Settings
    memory = var.memory

    # VM Disk
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    # VM Hard disk capacity
    disk{
       slot         = 0
        # set disk size here. leave it small for testing because expanding the disk takes time.
        size        = "${var.svr_disk["size"]}"
        type        = "${var.svr_disk["type"]}"
        storage     = "${var.svr_disk["storage"]}"
        # storage_type = "lvm"
        iothread    = 1 
        #backup      = true
    }

    # VM Network Settings
    network {
        bridge = "${var.svr_network["bridge"]}"
        model  = "${var.svr_network["model"]}"
        tag    = "${var.svr_network["tag"]}"
        firewall = true
    }

    lifecycle {
        ignore_changes = [
        network,
        ]
    }
    
    sshkeys = file(var.ssh_key_path["pub"])

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # VM IP Address and Gateway
    ipconfig0 = "ip=${var.svr_ip}/24,gw=${var.svr_gw}"
    nameserver = "${var.svr_nameservers}"
    

    # Default User & Password
    ciuser = var.svr_username
    cipassword = var.svr_password

    connection {
      type          = "ssh"
      host          = "${var.svr_ip}" 
      user          = "${var.svr_username}"
    #   password      = "${var.svr_password}"
      private_key   = "${file("${var.ssh_key_path["priv"]}")}"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get upgrade -y"
      ]
    }

    provisioner "local-exec" {
      working_dir = "../ansible"
      command = "ansible-playbook -u ${var.svr_username} --key-file ${var.ssh_key_path["priv"]} -i ${var.svr_ip}, setup-ssh-allow-password.yaml"
    }
}

# resource "null_resource" "provisioningAnsible" {
    
#     ## connection for ansible initialisation new vm created
#     connection {
#       type          = "ssh"
#       host          = "${var.svr_ip}" 
#       user          = "${var.svr_username}"
#     #   password      = "${var.svr_password}"
#       private_key   = "${file("${var.ssh_key_path["priv"]}")}"
#     }

#     provisioner "remote-exec" {
#       inline = [
#         "sudo apt-get update -y",
#         "sudo apt-get upgrade -y"
#       ]
#     }

#     provisioner "local-exec" {
#       working_dir = "../ansible"
#       command = "ansible-playbook -u ${var.svr_username} --key-file ${var.ssh_key_path["priv"]} -i ${var.svr_ip}, setup-ssh-allow-password.yaml"
#     }
# }