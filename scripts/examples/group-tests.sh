#!/bin/bash

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
