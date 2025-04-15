#!/bin/bash


if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi


# Example of executing some tests in succession
#
#./scripts/analyzer/upload-one.sh out/ansible/Ransomware.WannaCry/1s-5shards		wannacry-1s-5shards		wannacry
#./scripts/analyzer/upload-one.sh out/ansible/Ransomware.WannaCry/1s-10shards	wannacry-1s-10shards	wannacry
#./scripts/analyzer/upload-one.sh out/ansible/Ransomware.WannaCry/1s-50shards	wannacry-1s-50shards	wannacry
#./scripts/analyzer/upload-one.sh out/ansible/Ransomware.WannaCry/1s-200shards	wannacry-1s-200shards	wannacry
#./scripts/analyzer/upload-one.sh out/ansible/Ransomware.WannaCry/60s-200shards	wannacry-60s-200shards	wannacry
#
#./scripts/analyzer/upload-one.sh out/ansible/lockbit/1s-5shards				lockbit-1s-5shards		lockbit
#./scripts/analyzer/upload-one.sh out/ansible/lockbit/1s-10shards			lockbit-1s-10shards		lockbit
##./scripts/analyzer/upload-one.sh out/ansible/lockbit/1s-200shards			lockbit-1s-200shards	lockbit
#./scripts/analyzer/upload-one.sh out/ansible/lockbit/1s-200shards-other		lockbit-1s-200shards	lockbit
