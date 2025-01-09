#!/bin/bash

usage() {
  echo "ssh-windows.sh: ssh into Windows VM."
  echo "Usage: ssh-windows.sh"
  exit 1
}


if [[ ! -d scripts ]]; then
	echo "Run from root directory."
	usage
fi

if [[ ! -d out ]]; then
	mkdir out
fi


source scripts/read-vms.sh terraform/

sshpass -pPassw0rd! ssh -o StrictHostKeyChecking=no IEUser@${vm_ips[0]}