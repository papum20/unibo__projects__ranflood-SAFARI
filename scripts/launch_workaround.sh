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
  echo "launch.sh: Launch the full SAFARI project (destroy and re-deploy with terraform, run with ansible)."
  echo "	Destroy is needed because the VMs, after infecting them (and disabling its network interfaces), would be hard to access and also dangerous, "
  echo "	but also in order to provision them again, and getting their new IPs."
  echo "Usage: ./scripts/launch.sh [--c|-checker] [-d|--delete] [-D|--destroy] [-l LOG_FILE] [-h|--help]"
  echo "  -l LOG_FILE: If specified, log steps (also) to this file (no other verbose output)."
  echo "  -c: checker - Provision and run the filechecker VM."
  echo "  -d: delete - Delete the VMs first (useful to re-run provisioning, in case VMs IPs and IDs weren't saved)."
  echo "  -D: destroy - Delete only (no ansible)."
  echo "  -m: manual - Don't run terraform plan (but can run destroy) - useful after manualli editing vm.txt, if it wasn't edited by terraform."
  echo "  -h: help - Show this help message."
  exit 1
}

dir_ansible=ansible/
dir_ansible_variables=${dir_ansible}variables/
dir_terraform=terraform/
dir_current=$(pwd)
script_ansible=launch-ansible.sh

out_terraform_filename=vm.txt
path_log="/dev/null"

name_variables_ids=variables-vm-ids.generated.yml
name_variables_ips=variables-vm-ips.generated.yml


#
# ARGS
#

mode=flood
delete_only=false
terraform_delete=false
terraform_manual=false

while getopts ":cdDhm-:l:" opt; do
  case $opt in
    c)
      dir_ansible=${dir_ansible}checker/
      dir_ansible_variables=${dir_ansible}
      dir_terraform=terraform/checker/
      script_ansible=launch-ansible-checker.sh
      mode=checker
      ;;
    d)
      terraform_delete=true
      ;;
    D)
      delete_only=true
      ;;
    h)
      usage
      ;;
    m)
      terraform_manual=true
      ;;
    l)
      pat_log="$OPTARG"
      ;;
    -)
      case "${OPTARG}" in
        *)
          echo "Unknown option: --${OPTARG}"
          usage
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      usage
      ;;
  esac
done
shift $((OPTIND -1))


# Check path/required files
required_dirs=( \
	${dir_ansible} \
	scripts \
	${dir_terraform} 
)

for file in "${required_dirs[@]}"; do
    if [[ ! -d $file ]]; then
		echo "directories ${required_dirs[@]} not found. Make sure to run this script from the project's root directory." | tee -a $path_log
		usage
    fi
done

if [[ $mode == "flood" ]]; then 
  echo "[Script] Launching in flood mode" | tee -a $path_log
else
  echo "[Script] Launching in checker mode" | tee -a $path_log
fi


function launch-function() {

  #
  # Terraform
  #

  cd $dir_terraform


  echo "[Terraform] Launching terraform" | tee -a $path_log

  if [[ $delete_only == true || $terraform_delete == true ]]; then
    # clean previous VMs data
    rm ${out_terraform_filename}
    
    echo "[Terraform] Deleting previous VMs" | tee -a $path_log
    terraform destroy -auto-approve
  fi

  if [[ $delete_only == true ]]; then
    echo "[Terraform] Deleting only, skipping all." | tee -a $path_log
    exit 0
  fi

  if [[ $terraform_manual == false ]]; then
    echo "[Terraform] Provisioning new VMs" | tee -a $path_log
    terraform apply -auto-approve
  fi

  cd $dir_current

  # generate ansible variables
  if [[ $mode == "flood" ]]; then
    source scripts/util/read-vms.sh
  else 
    source scripts/util/read-vms.sh -c
  fi

  {
    echo "vm_ids:"
    for id in "${vm_ids[@]}"; do
      echo "  - $id"
    done
  } > "${dir_ansible_variables}/${name_variables_ids}"

  last_ip=
  {
    echo "vm_ips:"
    for ip in "${vm_ips[@]}"; do
      echo "  - $ip"
      last_ip=$ip

      # Remove known host, to avoid conflicts in ansible
      ssh-keygen -R $ip 1>/dev/null 2>&1
    done
  } > "${dir_ansible_variables}/${name_variables_ips}"

  # exit if last ip is empty
  if [[ -z $last_ip ]]; then
    echo "[Error] No VMs were created. Please edit manually vm.txt and retry with -m." | tee -a $path_log
    exit 1
  fi

  echo "vm_ids: ${vm_ids[@]}" >> $path_log
  echo "vm_ips: ${vm_ips[@]}" >> $path_log

  # old version, if checker VMs worked normally
  #
  #if [[ $mode == "flood" ]]; then
  #  ## Join
  #  disk_names_str=$(printf "%s, " "${disk_names[@]}")
  #  ## Remove the trailing comma and space
  #  disk_names_str=${disk_names_str%, }
  #  sed -i "/^vm_disk_to_check_name = {/,/^}/ \
  #    c\vm_disk_to_check_name = {\n  $disk_names_str\n}" \
  #    terraform/checker/terraform.auto.tfvars
  #
  #  if [[ -z $disk_names_str ]]; then
  #    echo "[Error] No disks were created. Please edit manually vm.txt and retry with -m."
  #    exit 1
  #  fi
  #fi

  if [[ $mode == "flood" ]]; then
    disk_names_str=$(printf "%s, " "${disk_names[@]}")
    ## Remove the trailing comma and space
    disk_names_str=${disk_names_str%, }
    if [[ -z $disk_names_str ]]; then
      echo "[Error] No disks were created. Please edit manually vm.txt and retry with -m." | tee -a $path_log
      exit 1
    fi

    echo "vm_disk_to_check_name: ${disk_names[@]}" >> $path_log
  fi


  #
  # Ansible
  #


  ## sometimes it won't connect, try to wait first
  sleep 10

  echo "[Ansible] Launching ansible" | tee -a $path_log
  "./scripts/${script_ansible}" -y

}



if [[ $mode == "flood" ]]; then
  launch-function

elif [[ $delete_only == false ]]; then
  # iterate over lines of vm.txt for windows  
  out_vmip=vm_ip
  out_vmid=vm_id
  out_diskname=disk_name
  while IFS= read -r line; do
    if [[ $line =~ ${out_vmip}=([0-9\.]+)\ ${out_vmid}=([0-9]+)\ ${out_diskname}=(.*) ]]; then
      win_vm_ip=("${BASH_REMATCH[1]}")
      win_vm_id=("${BASH_REMATCH[2]}")
      win_disk_name=("${BASH_REMATCH[3]}")

      if [[ -z $win_disk_name ]]; then
        echo "[Error] No disks were created. Please edit manually vm.txt and retry with -m." | tee -a $path_log
        exit 1
      else 
        echo "[Info] Checker, found Windows VM: $win_vm_ip, $win_vm_id, $win_disk_name" | tee -a $path_log
      fi

      sed -i "/^vm_disk_to_check_name = {/,/^}/ \
        c\vm_disk_to_check_name = {\n  $win_disk_name\n}" \
        terraform/checker/terraform.auto.tfvars

      launch-function
    fi
  done < terraform/vm.txt
fi
