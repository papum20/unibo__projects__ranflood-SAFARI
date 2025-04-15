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
  echo "launch-both-retry.sh: launch infected VM and then checker. Retry until all tests pass."
  echo "Usage: launch-both-retry.sh [-m|--manual] [TESTS_N=1] OUT_DIR"
  echo "    OUT_DIR: directory where ansible produces files (e.g. out/ansible/lockbit/)"
  exit 1
}


ignore_errors=false
terraform_manual=false
tests_n=1
out_dir=

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

  flags=
  if [[ $ignore_errors == true ]]; then
    flags="${flags} -i"
  fi
  if [[ $terraform_manual == true ]]; then
    flags="${flags} -m"
  fi

  ./scripts/launch-both.sh $flags $tests_to_do
done