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


echo "Transferring" && \
  ./scripts/ssh-scp-checker-to.sh ansible/files/checker/filechecker.jar && \

  echo "Removing old logs" && \
  ./scripts/ssh-checker.sh rm log* out* report* -f && \

  echo "Running checker" && \
  ./scripts/ssh-checker.sh "\
    java -jar /home/checker//filechecker.jar restore --debug --dry-run \
    -l=/home/checker/log.txt -e=/mnt/win10/Users/IEUser/AppData \
    -w=/mnt/win10/ --windows-letter=C \
    /home/checker/cleanWindowsChecksum \
    /home/checker/report-shards /home/checker/report /mnt/win10/Users/IEUser/ \
    > out.txt 2>&1" && \

  echo "Retrieving logs" && \
  ./scripts/ssh-scp-checker-out.sh
  