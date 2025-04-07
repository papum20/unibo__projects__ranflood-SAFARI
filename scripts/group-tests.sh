#!/bin/bash

# Example of executing some tests in succession


function set_name_ransomware() {
	echo "Setting name_ransomware to $1"
	
	# for test
	#sed "s/^name_ransomware=.*/name_ransomware=${1}/" ./ansible/variables/variables.sh

	sed -i "s/^name_ransomware=.*/name_ransomware=$1/" ./ansible/variables/variables.sh
}

function set_ranflood_start_delay() {
	echo "Setting ranflood_start_delay to $1"

	sed -i "s/^ranflood_start_delay:.*/ranflood_start_delay: $1/" ./ansible/variables/variables_internal.yml
}

function set_shards_created() {
	echo "Setting ShardsCreated to $1"
	
	sed -i "s/^ShardsCreated =.*/ShardsCreated = $1/" ./ansible/files/transfer/settings.ini
}

function ransomware_test() {

	if [[ $# -ne 4 ]]; then
		echo "Usage: $0 RANSOMWARE DELAY SHARDS TESTS"
		exit 1
	fi

	ransomware=$1
	delay=$2
	shards=$3
	tests=$4
	directory=./ansible/out/$ransomware/${delay}s-${shards}shards
	echo "Starting test: $ransomware, delay=${delay}s, shards=${shards}, tests=$tests, directory=$directory"

	if [[ ! -d $directory ]]; then
		set_name_ransomware $ransomware
		set_ranflood_start_delay $delay
		set_shards_created $shards
		mkdir -p $directory
		./scripts/launch-both-retry.sh $tests ./ansible/out/$ransomware
		find ./ansible/out/$ransomware/ -maxdepth 1 -name "192.168.*" -exec mv {} $directory \;
	else
		echo "Directory already exists, skipping..."
	fi
}


if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi


# New ones
# Birele ~ Winlocker , 7ev3n ~ Fantom

# no flooder
#ransomware_test Birele 620 200 2
#ransomware_test WinlockerVB6Blacksod 620 200 2
#ransomware_test 7ev3n 620 200 2
#ransomware_test Fantom 620 200 2
ransomware_test Vichingo455@Annabelle 620 200 2
exit 0

#ransomware_test Birele 1 200 3
#ransomware_test Birele 60 200 3

#ransomware_test WinlockerVB6Blacksod 1 200 3
ransomware_test WinlockerVB6Blacksod 60 200 3

#ransomware_test 7ev3n 1 200 3
ransomware_test 7ev3n 60 200 3

#ransomware_test Fantom 1 200 3
ransomware_test Fantom 60 200 3
