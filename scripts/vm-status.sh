#!/bin/bash

function usage() {
  echo "Change proxmox vm status."
  echo "Usage: $0 <start|shutdown> <vm_id>"
  exit 1
}

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
source variables.sh

echo "https://${proxmox_ip}:8006/api2/json/nodes/${proxmox_node}/qemu/${vm_id}/status/${endpoint}"
echo "Authorization: PVEAPIToken=${proxmox_user_pam}!${proxmox_status_token_id}=${proxmox_status_token_secret}"

curl -k -X POST "https://${proxmox_ip}:8006/api2/json/nodes/${proxmox_node}/qemu/${vm_id}/status/${endpoint}" \
  -H "Authorization: PVEAPIToken=${proxmox_user_pam}!${proxmox_status_token_id}=${proxmox_status_token_secret}"