#!/bin/bash

function usage() {
  echo "vm-status: Change proxmox vm status."
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
