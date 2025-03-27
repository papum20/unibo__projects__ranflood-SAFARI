#!/bin/bash

if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi


if [[ $# -ne 3 ]]; then
	echo "Usage: $0 FOLDER JSON_FILE RANSOMWARE"
	exit 1
fi

curl -X POST http://192.168.2.222:5000/upload \
	-H "api_key:c687196edcf3fc525c39a0a2db3a36ec" \
	-F "contrast=sss_ransomware" \
	-F "name_folder=$1" \
	-F "json_file=@${PWD}/$2" \
	-F "ransomware=$3" \
	-F "delay_contrast=60"