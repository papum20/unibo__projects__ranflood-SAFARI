#!/bin/bash

function usage() {
  echo "launch.sh: Launch the full SAFARI project (destroy and re-deploy with terraform, run with ansible)."
  echo "launch.sh: Launch the full SAFARI project (destroy and re-deploy with terraform, run with ansible)."
  echo "	Destroy is needed because the VMs, after infecting them (and disabling its network interfaces), would be hard to access and also dangerous, "
  echo "	but also in order to provision them again, and getting their new IPs."
  echo "Usage: ./scripts/launch.sh [--c|-checker] [-d|--delete] [-D|--destroy] [-h|--help]"
  echo "Usage: ./scripts/launch.sh [--c|-checker] [-d|--delete] [-D|--destroy] [-h|--help]"
  echo "  -c, --checker: Provision and run the filechecker VM."
  echo "  -d, --delete: Delete the VMs first (useful to re-run provisioning, in case VMs IPs and IDs weren't saved)."
  echo "  -D, --destroy: Delete only (no ansible)."
  echo "  -m, --manual: Don't run terraform plan (but can run destroy) - useful after manualli editing vm.txt, if it wasn't edited by terraform."
  echo "  -h, --help: Show this help message."
  exit 1
}

dir_ansible=ansible/
dir_ansible_variables=${dir_ansible}variables/
dir_terraform=terraform/
dir_current=$(pwd)
script_ansible=launch-ansible.sh

out_terraform_filename=vm.txt

name_variables_ids=variables-vm-ids.generated.yml
name_variables_ips=variables-vm-ips.generated.yml


#
# ARGS
#

mode=flood
delete_only=false
terraform_delete=false
terraform_manual=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c|--checker)
      dir_ansible=${dir_ansible}checker/
      dir_ansible_variables=${dir_ansible}
      dir_terraform=terraform/checker/
      script_ansible=launch-ansible-checker.sh
      mode=checker
      shift
      ;;
    -d|--delete)
      terraform_delete=true
      shift
      ;;
    -D|--destroy)
      delete_only=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    -m|--manual)
      terraform_manual=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Check path/required files
required_dirs=( \
	${dir_ansible} \
	scripts \
	${dir_terraform} 
)

for file in "${required_dirs[@]}"; do
    if [[ ! -d $file ]]; then
		echo "directories ${required_dirs[@]} not found. Make sure to run this script from the project's root directory."
		usage
    fi
done

if [[ $mode == "flood" ]]; then 
  echo "[Script] Launching in flood mode"
else
  echo "[Script] Launching in checker mode"
fi


function launch-function() {

  #
  # Terraform
  #

  cd $dir_terraform


  echo "[Terraform] Launching terraform"

  if [[ $delete_only == true || $terraform_delete == true ]]; then
    # clean previous VMs data
    rm ${out_terraform_filename}
    
    echo "[Terraform] Deleting previous VMs"
    terraform destroy -auto-approve
  fi

  if [[ $delete_only == true ]]; then
    echo "[Terraform] Deleting only, skipping all."
    exit 0
  fi

  if [[ $terraform_manual == false ]]; then
    echo "[Terraform] Provisioning new VMs"
    terraform apply -auto-approve
  fi

  cd $dir_current

  # generate ansible variables
  if [[ $mode == "flood" ]]; then
    source scripts/read-vms.sh
  else 
    source scripts/read-vms.sh -c
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
    echo "[Error] No VMs were created. Please edit manually vm.txt and retry with -m."
    exit 1
  fi

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
      echo "[Error] No disks were created. Please edit manually vm.txt and retry with -m."
      exit 1
    fi
  fi


  #
  # Ansible
  #


  ## sometimes it won't connect, try to wait first
  sleep 10

  echo "[Ansible] Launching ansible"
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
        echo "[Error] No disks were created. Please edit manually vm.txt and retry with -m."
        exit 1
      else 
        echo "[Info] Checker, found Windows VM: $win_vm_ip, $win_vm_id, $win_disk_name"
      fi

      sed -i "/^vm_disk_to_check_name = {/,/^}/ \
        c\vm_disk_to_check_name = {\n  $win_disk_name\n}" \
        terraform/checker/terraform.auto.tfvars

      launch-function
    fi
  done < terraform/vm.txt
fi
