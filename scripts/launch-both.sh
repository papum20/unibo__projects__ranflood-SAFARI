#!/bin/bash

function usage() {
  echo "launch-both.sh: launch infected VM and then checker."
  echo "Usage: launch-both.sh [-m|--manual]"
  exit 1
}

# ARGS
#

terraform_manual=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -m|--manual)
      terraform_manual=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done


if [[ $terraform_manual == true ]]; then
./scripts/launch-all.sh -c -D && \
  ./scripts/launch-all.sh -m && \
  ./scripts/launch-all.sh -c -d
else
./scripts/launch-all.sh -c -D && \
  ./scripts/launch-all.sh -d && \
  ./scripts/launch-all.sh -c -d
fi
