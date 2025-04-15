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
  echo "launch-both.sh: launch infected VM and then checker."
  echo "Usage: launch-both.sh [-m|--manual] [-i|--ignore-errors] [TESTS_N=1]"
  exit 1
}

ceil_divide() {
  local num=$1
  local denom=$2
  echo $(( (num + denom - 1) / denom ))
}

# test(bool TERRAFORM_MANUAL, bool IGNORE_ERRORS)
function test() {
  if [[ $1 == true ]]; then
    # retry checker 3 times
    ./scripts/launch.sh -c -D -l "$path_log" && \
      ( ./scripts/launch.sh -m -l "$path_log" || \
        $2 == true ) && \
      ( ./scripts/launch.sh -c -d -l "$path_log" || \
        ./scripts/launch.sh -c -d -l "$path_log" || \
        ./scripts/launch.sh -c -d -l "$path_log" )
  else
    ./scripts/launch.sh -c -D -l "$path_log" && \
      ( ./scripts/launch.sh -d -l "$path_log" || \
        $2 == true ) && \
      ( ./scripts/launch.sh -c -d -l "$path_log" || \
        ./scripts/launch.sh -c -d -l "$path_log" || \
        ./scripts/launch.sh -c -d -l "$path_log" )
  fi
}


timestamp=$(date +'%Y%m%d-%H_%M_%S')

# max number of tests which can be executed in parallel (set manually in terraform)
tests_parallel=4
path_out="${PWD}/out/scripts/launch-both_${timestamp}.out"
path_log="${PWD}/out/scripts/launch-both_${timestamp}.log"
mkdir -p out



#
# ARGS
#

ignore_errors=false
terraform_manual=false
tests_n=1

while getopts ":mi-:" opt; do
  case $opt in
    i)
      ignore_errors=true
      ;;
    m)
      terraform_manual=true
      ;;
    -)
      case "${OPTARG}" in
        manual)
          terraform_manual=true
          ;;
        ignore-errors)
          ignore_errors=true
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
echo "Running $tests_n tests in $test_batches_n batches of $tests_parallel tests each..." | tee -a "$path_log"


test_completed=0

# Loop for the number of tests
for ((i=1; i<=test_batches_n; i++)); do
  echo "Running test $i of $tests_n" | tee -a "$path_log"
  test $terraform_manual $ignore_errors
  tests_completed=$((tests_completed+tests_parallel))
  echo "Test batch completed: $i (tot: $tests_completed / $tests_n)" | tee -a "$path_log"
  # write down new ips
  source scripts/util/read-vms.sh
  echo "[$(date +'%Y%m%d-%H_%M_%S')] windows IPs: ${vm_ips[@]}" | tee -a "$path_log" >> "$path_out"
  source scripts/util/read-vms.sh -c
  echo "[$(date +'%Y%m%d-%H_%M_%S')] checker IPs: ${vm_ips[@]}" | tee -a "$path_log" >> "$path_out"
done

echo "Completed tests: $tests_completed / $tests_n" | tee -a "$path_log"
