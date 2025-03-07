#!/bin/bash

function usage() {
  echo "launch-both-retry.sh: launch infected VM and then checker. Retry until all tests pass."
  echo "Usage: launch-both-retry.sh [-m|--manual] [TESTS_N=1] OUT_DIR"
  echo "    OUT_DIR: directory where ansible produces files (e.g. ansible/out/lockbit/)"
  exit 1
}


terraform_manual=false
tests_n=1
out_dir=

while getopts ":m-:" opt; do
  case $opt in
    m)
      terraform_manual=true
      ;;
    -)
      case "${OPTARG}" in
        manual)
          terraform_manual=true
          ;;
        *)
          echo "Unknown option: --${OPTARG}"
          usage
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      usage
      ;;
  esac
done
shift $((OPTIND -1))

if [[ -n "$1" && "$1" =~ ^[0-9]+$ ]]; then
  tests_n="$1"
  # clear args, so won't have problem with next source
  shift
fi

if [[ -n "$1" ]]; then
  out_dir="$1"
  shift
else
  usage
fi


tests_to_do=$tests_n
while [[ $(./scripts/util/out-count-results.sh $out_dir) -lt $tests_n ]]; do
  tests_to_do=$((tests_n - $(./scripts/util/out-count-results.sh $out_dir)))
  echo "Running $tests_to_do tests..."

  if [[ $terraform_manual == true ]]; then
    ./scripts/launch-both.sh -m $tests_to_do
  else
    ./scripts/launch-both.sh $tests_to_do
  fi
done