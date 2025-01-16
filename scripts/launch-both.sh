#!/bin/bash

function usage() {
  echo "launch-both.sh: launch infected VM and then checker."
  echo "Usage: launch-both.sh [-m|--manual] [TESTS_N=1]"
  exit 1
}

ceil_divide() {
  local num=$1
  local denom=$2
  echo $(( (num + denom - 1) / denom ))
}

# test(bool TERRAFORM_MANUAL)
function test() {
  echo $1
  if [[ $1 == true ]]; then
    ./scripts/launch.sh -c -D && \
      ./scripts/launch.sh -m && \
      ./scripts/launch.sh -c -d
  else
    ./scripts/launch.sh -c -D && \
      ./scripts/launch.sh -d && \
      ./scripts/launch.sh -c -d
  fi
}


# max number of tests which can be executed in parallel (set manually in terraform)
tests_parallel=1
path_out=out/launch-both.log
mkdir out


#
# ARGS
#

terraform_manual=false
tests_n=1

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

if [[ -n "$1" ]]; then
  tests_n="$1"
  # clear args, so won't have problem with next source
  shift
fi

test_batches_n=$(ceil_divide $tests_n $tests_parallel)
echo "Running $tests_n tests in $test_batches_n batches of $tests_parallel tests each..."


test_completed=0

# Loop for the number of tests
for ((i=1; i<=test_batches_n; i++)); do
  echo "Running test $i of $tests_n"
  test $terraform_manual
  tests_completed=$((tests_completed+tests_parallel))
  echo "Test batch completed: $i (tot: $tests_completed / $tests_n)"
  # write down new ips
  source scripts/read-vms.sh
  echo "[$(date +'%Y%m%d-%H_%M_%S')] windows IPs: ${vm_ips[@]}" >> "$path_out"
  source scripts/read-vms.sh -c
  echo "[$(date +'%Y%m%d-%H_%M_%S')] checker IPs: ${vm_ips[@]}" >> "$path_out"
done

echo "Completed tests: $tests_completed / $tests_n"
