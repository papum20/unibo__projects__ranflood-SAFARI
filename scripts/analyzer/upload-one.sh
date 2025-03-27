#!/bin/bash


if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi

if [[ $# -ne 3 ]]; then
	echo "Usage: $0 LOCAL_FOLDER_PATH REMOTE_FOLDER_NAME RANSOMWARE"
	echo "    LOCAL_FOLDER_PATH: where tests reports can be found (recursively)"
	echo "    REMOTE_FOLDER_NAME: name of the remote folder to create and upload to (will be prefixed with 'test-sss-v2-')"
	echo "    RANSOMWARE: name of the ransomware"
	exit 1
fi

LOCAL_FOLDER_PATH=$1
REMOTE_FOLDER="test-sss-v20250327_2-$2"
RANSOMWARE=$3

source scripts/analyzer/analyzer.secret.sh


curl -X POST http://192.168.2.222:5000/upload_base \
	-H "api_key:$API_KEY" \
	-F "name_folder=${REMOTE_FOLDER}" \
	-F "json_file=@${PWD}/scripts/analyzer/cleanWindowsChecksum_filtered.json"



# copy to json
find ${LOCAL_FOLDER_PATH} -name 'report2*' -not -name '*.json' -exec mv {} {}.json \;
# replace \ w/ \\
find ${LOCAL_FOLDER_PATH} -name 'report2*' -name '*.json' -exec sed -ri 's/([^\\])\\([^\\])/\1\\\\\2/g' {} \;
# flatten filter out
find ${LOCAL_FOLDER_PATH} -name 'report2*' -name '*.json' -exec python3 ./scripts/python/report-flatten-filter.py {} \;
# upload
find ${LOCAL_FOLDER_PATH} -name 'flattened_filtered_report2*' -exec ./scripts/analyzer/upload.sh ${REMOTE_FOLDER} {} $RANSOMWARE \;



curl -X POST http://192.168.2.222:5000/aggregator \
	-H "api_key:$API_KEY" \
	-F "name_folder=${REMOTE_FOLDER}"

