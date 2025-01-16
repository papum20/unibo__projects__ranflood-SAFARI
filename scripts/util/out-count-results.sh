#!/bin/bash

usage() {
	echo "out-count-results.sh: count the number of results in the out directory."
	echo "Usage: out-count-results.sh [OUT_DIR]"
	echo "  OUT_DIR: the directory to search for results."
	echo "Example: out-count-results.sh ansible/out/Ransomware.WannaCry/"
	exit 1
}


#
# ARGS
#

if [[ -z "$1" || ! -d "$1" ]]; then
	usage
fi


find $1 -name report* | egrep -v shards | wc -l
