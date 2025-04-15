#!/bin/bash

#/******************************************************************************
# * Copyright 2025 (C) by Daniele D'Ugo <danieledugo1@gmail.com>               *
# *                                                                            *
# * This program is free software; you can redistribute it and/or modify       *
# * it under the terms of the GNU Library General Public License as            *
# * published by the Free Software Foundation; either version 2 of the         *
# * License, or (at your option) any later version.                            *
# *                                                                            *
# * This program is distributed in the hope that it will be useful,            *
# * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
# * GNU General Public License for more details.                               *
# *                                                                            *
# * You should have received a copy of the GNU Library General Public          *
# * License along with this program; if not, write to the                      *
# * Free Software Foundation, Inc.,                                            *
# * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                  *
# *                                                                            *
# * For details about the authors of this software, see the AUTHORS file.      *
# ******************************************************************************/


function usage() {
  echo "vm-status: Change proxmox vm status (through API)."
  echo "Usage: $0 <start|shutdown> <vm_id>"
  exit 1
}

if [[ ! -f scripts/variables.secret.sh ]]; then
  echo "variables.secret.sh not found. Make sure to run this script from the project's root directory."
  usage
fi

cd scripts


# Check if action and VM ID are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  usage
fi

action=$1
vm_id=$2

# Validate action argument
if [ "$action" == "start" ]; then
  endpoint="start"
elif [ "$action" == "shutdown" ]; then
  endpoint="shutdown"
else
  usage
fi

echo $endpoint

set -a
source variables.secret.sh

echo "https://${proxmox_ip}:8006/api2/json/nodes/${proxmox_node}/qemu/${vm_id}/status/${endpoint}"
echo "Authorization: PVEAPIToken=${proxmox_status_user}!${proxmox_status_token_id}=${proxmox_status_token_secret}"

curl -k -X POST "https://${proxmox_ip}:8006/api2/json/nodes/${proxmox_node}/qemu/${vm_id}/status/${endpoint}" \
  -H "Authorization: PVEAPIToken=${proxmox_status_user}!${proxmox_status_token_id}=${proxmox_status_token_secret}"
