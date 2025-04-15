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


if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi


if [[ $# -ne 3 ]]; then
	echo "Usage: $0 FOLDER JSON_FILE RANSOMWARE"
	exit 1
fi

curl -X POST http://192.168.2.222:5000/upload \
	-H "api_key:c687196edcf3fc525c39a0a2db3a36ec" \
	-F "contrast=sss_ransomware" \
	-F "name_folder=$1" \
	-F "json_file=@${PWD}/$2" \
	-F "ransomware=$3" \
	-F "delay_contrast=60"