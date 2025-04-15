#!/bin/bash

#/******************************************************************************
# * Copyright 2025 (C) by Daniele D'Ugo <danieledugo1@gmail.com>               *
# *                                                                            *
# * This program is free software; you can redistribute it and/or modify       *
# * it under the terms of the GNU Library General Public License as            *
# * published by the Free Software Foundation; either version 2 of the         *
# * License, or (at your option) any later version.                            *
# *                                                                            *
# * This program is distributed in the hope that it will be useful,            *
# * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
# * GNU General Public License for more details.                               *
# *                                                                            *
# * You should have received a copy of the GNU Library General Public          *
# * License along with this program; if not, write to the                      *
# * Free Software Foundation, Inc.,                                            *
# * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                  *
# *                                                                            *
# * For details about the authors of this software, see the AUTHORS file.      *
# ******************************************************************************/


function usage() {
	echo "Usage: test-ransomware.sh RANSOMWARE DELAY SHARDS TESTS"
	echo "	RANSOMWARE: Name of the ransomware to test (same name as the archive file, without extension)"
	echo "	DELAY: Delay in seconds between the start of ransomware and flooding"
	echo "	SHARDS: Number of shards to create for Ranflood-SSS"
	echo "	TESTS: Number of tests to run and complete (won't stop until all tests are present)"
	exit 1
}


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
		usage
	fi

	ransomware=$1
	delay=$2
	shards=$3
	tests=$4
	directory=./out/ansible/$ransomware/${delay}s-${shards}shards
	echo "Starting test: $ransomware, delay=${delay}s, shards=${shards}, tests=$tests, directory=$directory"

	if [[ ! -d $directory ]]; then
		mkdir -p $directory
	fi

	tests_to_do=$((tests - $(./scripts/util/out-count-results.sh $directory)))

	if [[ $tests_to_do -le 0 ]]; then
		echo "All tests already done, skipping..."
		return
	else 
		echo "Some tests were already found, running $tests_to_do remaining tests..."
		set_name_ransomware $ransomware
		set_ranflood_start_delay $delay
		set_shards_created $shards
		mkdir -p $directory
		./scripts/launch-both-retry.sh -i $tests_to_do ./out/ansible/$ransomware
		find ./out/ansible/$ransomware/ -maxdepth 1 -name "192.168.*" -exec mv {} $directory \;
	fi
}


if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi


ransomware_test "$@"
