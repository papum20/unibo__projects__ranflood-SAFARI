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
	echo "out-count-results.sh: count the number of results in the out directory."
	echo "Usage: out-count-results.sh [OUT_DIR]"
	echo "  OUT_DIR: the directory to search for results."
	echo "Example: out-count-results.sh out/ansible/Ransomware.WannaCry/"
	exit 1
}


#
# ARGS
#

if [[ -z "$1" || ! -d "$1" ]]; then
	usage
fi


regex_ip="$1/?([0-9]+\.){3}[0-9]+.*"

# only direct subfolders
find $1 -name report* | egrep -v 'shards[^/]*$' | egrep $regex_ip | wc -l

# also in subfolders
#find $1 -name report* | egrep -v shards | wc -l
