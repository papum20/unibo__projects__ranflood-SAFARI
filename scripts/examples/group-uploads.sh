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
