#!/bin/bash

function usage() {
  echo "read-vms: Read data of the VMs generated with SAFARI's terraform scripts, and export them as variables."
  echo "  vm_ids: Array of VM IDs"
  echo "  vm_ips: Array of VM IPs"
  echo "Usage: $0 [DIR_TERRAFORM=terraform]"
  echo "  DIR_TERRAFORM: Directory where the terraform scripts are located."
  exit 1
}

dir_terraform=terraform

# Output file of terraform
out_filename=vm.txt
# Output variables
out_vmip=vm_ip
out_vmid=vm_id


#
# ARGS
#

# Parse optional arguments
if [ $# -ge 1 ]; then
  dir_terraform=$1
fi

if [[ ! -d ${dir_terraform} ]]; then
  echo "${dir_terraform} not found. Make sure to run this script from the project's root directory."
  usage
fi


#
# Read VMs
#

vm_ips=()
vm_ids=()

while IFS= read -r line; do
  if [[ $line =~ ${out_vmip}=([0-9\.]+)\ ${out_vmid}=([0-9]+) ]]; then
      vm_ips+=("${BASH_REMATCH[1]}")
      vm_ids+=("${BASH_REMATCH[2]}")
  fi
done < ${dir_terraform}/vm.txt


export vm_ips=${vm_ips}
export vm_ids=${vm_ids}

echo "VM IPs: ${vm_ips[@]}"
echo "VM IDs: ${vm_ids[@]}"
