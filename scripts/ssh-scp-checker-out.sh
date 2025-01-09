#!/bin/bash

usage() {
	echo "ssh-scp-checker.sh: scp copy checker report files."
	echo "Usage: ssh-scp-checker.sh"
	exit 1
}


if [[ ! -d scripts ]]; then
	echo "Run from root directory."
	usage
fi

if [[ ! -d out ]]; then
	mkdir out
fi


source scripts/read-vms.sh terraform/checker/

sshpass -pchecker scp checker@${vm_ips[0]}:~/report* out
sshpass -pchecker scp checker@${vm_ips[0]}:~/out* out
sshpass -pchecker scp checker@${vm_ips[0]}:~/log* out
