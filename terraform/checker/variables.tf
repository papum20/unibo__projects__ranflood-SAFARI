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

variable "proxmox_api_url" {
	type = string
}

variable "proxmox_api_token_id" {
	type = string
}

variable "proxmox_api_token_secret" {
	type = string
}


variable "vm_name" {
	type = string
}

variable "target_nodes" {
	type = list(string)
	description = "Nodes that will be used to deploy the VMs, in order (when necessary)."
}

variable "vm_id" {
	type = number
}

variable "template_clones" {
    type = list(string)
    description = "Templates to clone the VMs from, in order (when necessary). Make sure that their order respects their relative node (target_nodes)."
	validation {
        condition = length(var.target_nodes) == length(var.template_clones)
        error_message = "target_nodes and template_clones must have the same length."
    }
}

variable "is_full_clone" {
	type = bool
}

variable "vm_qemu_agent" {
	type = number
}

variable "vm_qemu_agent_timeout" {
	type = number
}

variable "vm_memory" {
	type = number
}


variable "vm_sockets" {
	type = number
}

variable "vm_cores" {
	type = number
}


variable "vm_scsihw" {
	type = string
}

variable "vm_ipconfig" {
	type = string
}   


variable "vm_network_card_model" {
	type = string
}

variable "vm_bootdisk" {
	type = string
}

variable "vm_network_bridge" {
	type = string
}

variable "vm_disk_storage" {
	type = string
}

variable "vm_disk_size" {
	type = string
}

variable "vm_disk_to_check_name" {
	type = list(string)
	description = "List of disks to be checked by each VM."
}


locals {
	# VMs number equals the disks to mount and check
	vms_count = length(var.vm_disk_to_check_name)
	# indices of template and node to use
    node_indices = [
        for idx in range(local.vms_count) : idx % length(var.target_nodes)
    ]
}
