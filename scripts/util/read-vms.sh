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
  echo "read-vms: Read data of the VMs generated with SAFARI's terraform scripts, and export them as variables."
  echo "  vm_ids: Array of VM IDs"
  echo "  vm_ips: Array of VM IPs"
  echo "Usage: ./scripts/util/read-vms.sh [-c]"
  echo "  -c: Checker mode."
  exit 1
}


# Output file of terraform
out_filename=vm.txt
# Output variables
out_vmip=vm_ip
out_vmid=vm_id
out_diskname=disk_name


#
# ARGS
#

mode=flood
dir_terraform=terraform

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c)
      mode=checker
      dir_terraform=${dir_terraform}/checker
      shift
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

if [[ ! -d ${dir_terraform} ]]; then
  echo "${dir_terraform} not found. Make sure to run this script from the project's root directory."
  usage
fi


#
# Read VMs
#

vm_ips=()
vm_ids=()
disk_names=()

case $mode in
  flood)
    while IFS= read -r line; do
      if [[ $line =~ ${out_vmip}=([0-9\.]+)\ ${out_vmid}=([0-9]+)\ ${out_diskname}=(.*) ]]; then
          vm_ips+=("${BASH_REMATCH[1]}")
          vm_ids+=("${BASH_REMATCH[2]}")
          disk_names+=("${BASH_REMATCH[3]}")
      fi
    done < ${dir_terraform}/vm.txt
    ;;
  checker)
    while IFS= read -r line; do
      if [[ $line =~ ${out_vmip}=([0-9\.]+)\ ${out_vmid}=([0-9]+) ]]; then
          vm_ips+=("${BASH_REMATCH[1]}")
          vm_ids+=("${BASH_REMATCH[2]}")
      fi
    done < ${dir_terraform}/vm.txt
    ;;
esac



export vm_ips=${vm_ips}
export vm_ids=${vm_ids}
export disk_names=${disk_names}

echo "VM IPs: ${vm_ips[@]}"
echo "VM IDs: ${vm_ids[@]}"
echo "Disk Names: ${disk_names[@]}"
