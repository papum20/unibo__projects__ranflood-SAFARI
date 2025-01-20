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

    count = var.vms_count

    name        = "${var.vm_name}-${count.index}"
    target_node = var.target_nodes[local.node_indices[count.index]]
    vmid        = sum([var.vm_id, count.index])
    clone       = var.template_clones[var.target_nodes[local.node_indices[count.index]]]
    full_clone  = var.is_full_clone

    memory          = var.vm_memory
    cores           = var.vm_cores
    sockets         = var.vm_sockets
    agent           = var.vm_qemu_agent
    agent_timeout   = var.vm_qemu_agent_timeout

    scsihw = var.vm_scsihw
    bootdisk = var.vm_bootdisk

    # assign an automatic ip for ssh (readable from self.ssh_host)
    ipconfig0 = "ip=dhcp"


    disks {
        ide {
            ide0 {
                disk {
                    storage = var.vm_disk_storage
                    size    = var.vm_disk_size
                }
            }
        }
    }

    network {
        model   = var.vm_network_card_model
        bridge  = var.vm_network_bridge
      }

    provisioner "local-exec" {
        command = <<EOT
            echo "vm_ip=${self.ssh_host} vm_id=${self.vmid} disk_name=\"${var.vm_disk_storage}:vm-${self.vmid}-disk-${self.disks[0].ide[0].ide0[0].disk[0].id}\" = \"${self.target_node}\"" >> vm.txt
        EOT
    }

}
