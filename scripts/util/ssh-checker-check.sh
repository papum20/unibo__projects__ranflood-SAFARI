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


usage() {
  echo "ssh-checker.sh: ssh into checker VM."
  echo "All args will be passed at the end of the ssh call (e.g. you can add a command to execute remotely)."
  echo "Usage: ssh-checker.sh [ARGS...]"
  exit 1
}


if [[ ! -d scripts ]]; then
	echo "Run from root directory."
	usage
fi


echo "Transferring" && \
  ./scripts/util/ssh-scp-checker-to.sh ansible/files/checker/filechecker.jar && \

  echo "Removing old logs" && \
  ./scripts/util/ssh-checker.sh rm log* out* report* -f && \

  echo "Running checker" && \
  ./scripts/util/ssh-checker.sh "\
    java -jar /home/checker//filechecker.jar restore --debug --dry-run \
    -l=/home/checker/log.txt -e=/mnt/win10/Users/IEUser/AppData \
    -w=/mnt/win10/ --windows-letter=C \
    /home/checker/cleanWindowsChecksum \
    /home/checker/report-shards /home/checker/report /mnt/win10/Users/IEUser/ \
    > out.txt 2>&1" && \

  echo "Retrieving logs" && \
  ./scripts/util/ssh-scp-checker-out.sh
  