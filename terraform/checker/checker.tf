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

resource "proxmox_vm_qemu" "checker" {

    count = local.vms_count

    name        = "${var.vm_name}-${count.index}"
    target_node = var.target_nodes[local.node_indices[count.index]]
    vmid        = sum([var.vm_id, count.index])
    clone       = var.template_clones[local.node_indices[count.index]]
    full_clone  = var.is_full_clone

    memory        = var.vm_memory
    cores         = var.vm_cores
    sockets       = var.vm_sockets
    agent         = var.vm_qemu_agent
    agent_timeout = var.vm_qemu_agent_timeout

    scsihw    = var.vm_scsihw
    bootdisk  = var.vm_bootdisk

    ipconfig0 = var.vm_ipconfig


    disks {
        scsi {
            scsi0 {
                disk {
                    storage = var.vm_disk_storage
                    size    = var.vm_disk_size
                }
            }
        }

        ide {
          ide0 {
            passthrough {
              file = element(var.vm_disk_to_check_name, count.index)
            }
          }
        }

        sata {
          sata0 {
            disk {
              storage = "storage-condiviso"
              size = "1G"
            }
          }
        }

    }

    network {
        model   = var.vm_network_card_model
        bridge  = var.vm_network_bridge
      }


    provisioner "local-exec" {
        command = "echo \"vm_ip=${self.ssh_host} vm_id=${self.vmid}\" >> vm.txt"
    }

}
