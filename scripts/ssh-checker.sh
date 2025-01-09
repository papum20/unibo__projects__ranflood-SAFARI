#!/bin/bash

usage() {
  echo "ssh-checker.sh: ssh into checker VM."
  echo "All args will be passed at the end of the ssh call (e.g. you can add a command to execute remotely)."
  echo "Usage: ssh-checker.sh [ARGS...]"
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


sshpass -pchecker ssh -o StrictHostKeyChecking=no checker@${vm_ips[0]} $@
