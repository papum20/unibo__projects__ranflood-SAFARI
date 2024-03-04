/******************************************************************************
 * Copyright 2021 (C) by Tommaso Compagnucci <tommasocompagnucci1@gmail.com>  *
 *                                                                            *
 * This program is free software; you can redistribute it and/or modify       *
 * it under the terms of the GNU Library General Public License as            *
 * published by the Free Software Foundation; either version 2 of the         *
 * License, or (at your option) any later version.                            *
 *                                                                            *
 * This program is distributed in the hope that it will be useful,            *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 * GNU General Public License for more details.                               *
 *                                                                            *
 * You should have received a copy of the GNU Library General Public          *
 * License along with this program; if not, write to the                      *
 * Free Software Foundation, Inc.,                                            *
 * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                  *
 *                                                                            *
 * For details about the authors of this software, see the AUTHORS file.      *
 ******************************************************************************/

resource "proxmox_vm_qemu" "windows_clone" {
  
    count = var.vms-count
    

    //top level block

    name = "${var.vm_name}-${count.index}"
    target_node = var.target_node
    vmid = sum([var.vm_id, count.index])
    clone = var.template_clone
    bios = var.vm_bios
    agent = 1
    ipconfig0 = var.vm_ip
    full_clone = false

    sockets = var.vm_sockets
    cores = var.vm_cores
    memory = var.vm_memory

    scsihw = var.vm_scsi

    //disk block

    disk {
        type = var.vm_disk_type
        storage = var.vm_disk_storage
        size = var.vm_disk_size
        backup = true
    }

    // network block

    network {
        model = var.network_card_model
        bridge = var.network_bridge
    }


    provisioner "local-exec" {
      command = "echo ${self.ssh_host} >> vm_ip_address.txt"
    }

}
