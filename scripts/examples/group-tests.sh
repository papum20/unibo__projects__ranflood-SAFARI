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
# no flooder (620s activation > shutdown timer)
#./scripts/test-ransomware.sh Birele 620 200 2
#./scripts/test-ransomware.sh WinlockerVB6Blacksod 620 200 2
#./scripts/test-ransomware.sh 7ev3n 620 200 2
#./scripts/test-ransomware.sh Fantom 620 200 2
#./scripts/test-ransomware.sh Vichingo455@Annabelle 620 200 5
#./scripts/test-ransomware.sh Ransomware.Petya 620 200 5

#./scripts/test-ransomware.sh Birele 1 200 3
#./scripts/test-ransomware.sh Birele 60 200 3

#./scripts/test-ransomware.sh WinlockerVB6Blacksod 1 200 3
#./scripts/test-ransomware.sh WinlockerVB6Blacksod 60 200 3

#./scripts/test-ransomware.sh 7ev3n 1 200 3
#./scripts/test-ransomware.sh 7ev3n 60 200 3

#./scripts/test-ransomware.sh Fantom 1 200 3
#./scripts/test-ransomware.sh Fantom 60 200 3
