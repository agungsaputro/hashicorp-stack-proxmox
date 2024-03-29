# Ubuntu Server Focal
# ---
# Packer Template to create an Ubuntu Server (Focal) on Proxmox

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

# Resource Definiation for the VM Template
source "proxmox" "ubuntu-server-focal" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    # insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "proxmox139"
    vm_id = "102"
    vm_name = "ubuntu-template"
    template_description = "Ubuntu Server Focal Image"

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "Nfs-ISO-Proxmox5:iso/ubuntu-22.04-live-server-amd64.iso"
    # - or -
    # (Option 2) Download ISO
    // iso_url = "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
    // iso_checksum = "caf3fd69c77c439f162e2ba6040e9c320c4ff0d69aad1340a514319a9264df9f"
    // iso_checksum_type: "sha256"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "1G"
        format = "qcow2"
        storage_pool = "hdd"
        storage_pool_type = "lvm"
        type = "virtio"
    }

    # VM CPU Settings
    cores = "1"
    
    # VM Memory Settings
    memory = "2048" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr4"
        firewall = "true"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "hdd"

    # PACKER Boot Commands
    boot_command = [
        // "<esc><wait><esc><wait>",
        // "<f6><wait><esc><wait>",
        // "<bs><bs><bs><bs><bs>",
        // "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        // "--- <enter>"
        "<esc><wait><esc><wait><f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        "--- <enter>"

    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    # (Optional) Bind IP Address and Port
    # http_bind_address = "0.0.0.0"
    # http_port_min = 8802
    # http_port_max = 8802

    ssh_username = "test2"

    # (Option 1) Add your Password here
    ssh_password = "test2"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    # ssh_private_key_file = "~/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server-focal"
    sources = ["source.proxmox.ubuntu-server-focal"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "file/svr-pve.cfg"
        destination = "/tmp/svr-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/svr-pve.cfg /etc/cloud/cloud.cfg.d/svr-pve.cfg" ]
    }

    # Add additional provisioning scripts here
    # ...
    # install docker
    // provisioner "shell"{
    //     inline = [
    //         "sudo apt-get remove docker docker-engine docker.io containerd runc",
    //         "sudo apt-get update",
    //         "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release",
    //         "sudo mkdir -p /etc/apt/keyrings",
    //         "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
    //         "echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    //         "sudo apt-get update",
    //         "sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin",
    //         # specific docker version
    //         #"sudo apt-get install -y docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io docker-compose-plugin",
    //         "sudo groupadd docker",
    //         "sudo usermod -aG docker $USER",
    //         "sudo systemctl enable docker",
    //         "sudo systemctl start docker",
    //     ]
    // }
}