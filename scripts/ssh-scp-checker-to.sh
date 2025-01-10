#!/bin/bash

usage() {
	echo "ssh-scp-checker.sh: scp copy checker report files."
	echo "Usage: ssh-scp-checker.sh LOCAL_FILE REMOTE_FILE"
	exit 1
}


if [[ ! -d scripts ]]; then
	echo "Run from root directory."
	usage
fi

if [[ ! -d out ]]; then
	mkdir out
fi


source scripts/read-vms.sh -c

sshpass -pchecker scp "$1" checker@${vm_ips[0]}:"$2"
