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

proxmox_api_url = "https://192.168.1.129:8006/api2/json"
proxmox_api_token_id = "root@pam!safari"
proxmox_api_token_secret = "token_secret"

vms-count = 1

vm_name = "testEnvVM"
target_node = "pve"
vm_id = 152
template_clone = "finalTemplateWithSnapshots"

vm_memory = 6144

vm_sockets = 1
vm_cores = 4

network_card_model = "e1000"
network_bridge = "vmbr0"


vm_disk_type = "ide"
vm_disk_storage = "local-lvm"
vm_disk_size = "100G"

vm_scsi = "virtio-scsi-pci"

vm_bios = "seabios"

vm_ip = "ip=dhcp"

vm_user = "IEUser"
vm_password = "Passw0rd!"