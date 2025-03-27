#!/bin/bash

./scripts/analyzer/upload-one.sh ansible/out/Ransomware.WannaCry/1s-5shards		wannacry-1s-5shards		wannacry
./scripts/analyzer/upload-one.sh ansible/out/Ransomware.WannaCry/1s-10shards	wannacry-1s-10shards	wannacry
./scripts/analyzer/upload-one.sh ansible/out/Ransomware.WannaCry/1s-50shards	wannacry-1s-50shards	wannacry
./scripts/analyzer/upload-one.sh ansible/out/Ransomware.WannaCry/1s-200shards	wannacry-1s-200shards	wannacry
./scripts/analyzer/upload-one.sh ansible/out/Ransomware.WannaCry/60s-200shards	wannacry-60s-200shards	wannacry

./scripts/analyzer/upload-one.sh ansible/out/lockbit/1s-5shards				lockbit-1s-5shards		lockbit
./scripts/analyzer/upload-one.sh ansible/out/lockbit/1s-10shards			lockbit-1s-10shards		lockbit
#./scripts/analyzer/upload-one.sh ansible/out/lockbit/1s-200shards			lockbit-1s-200shards	lockbit
./scripts/analyzer/upload-one.sh ansible/out/lockbit/1s-200shards-other		lockbit-1s-200shards	lockbit
