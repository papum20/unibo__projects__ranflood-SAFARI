#!/bin/bash

#
# This is an old version of the upload-one script, more hard-coded.
# Use the other one, which also accepts parameters.
#

if [[ ! -d scripts ]]; then
	echo "Run this script from the root directory of the repository"
	exit 1
fi


source scripts/analyzer/analyzer.secret.sh
FOLDER=test-sss-filtered-4


curl -X POST http://192.168.2.222:5000/upload_base \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-phobos" \
	-F "json_file=@${PWD}/scripts/analyzer/res/cleanWindowsChecksum_filtered.json"

curl -X POST http://192.168.2.222:5000/upload_base \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-lockbit" \
	-F "json_file=@${PWD}/scripts/analyzer/res/cleanWindowsChecksum_filtered.json"

curl -X POST http://192.168.2.222:5000/upload_base \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-wannacry" \
	-F "json_file=@${PWD}/scripts/analyzer/res/cleanWindowsChecksum_filtered.json"

curl -X POST http://192.168.2.222:5000/upload_base \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-vipasana" \
	-F "json_file=@${PWD}/scripts/analyzer/res/cleanWindowsChecksum_filtered.json"


# copy to json
find out/ansible/phobos.bin/good/ -name 'report2*' -not -name '*.json' -exec mv {} {}.json \;
# replace \ w/ \\
find out/ansible/phobos.bin/good/ -name 'report2*' -name '*.json' -exec sed -ri 's/([^\\])\\([^\\])/\1\\\\\2/g' {} \;
# flatten filter out
find out/ansible/phobos.bin/good/ -name 'report2*' -name '*.json' -exec python3 ./scripts/python/report-flatten-filter.py {} \;
# upload
find out/ansible/phobos.bin/good/ -name 'flattened_filtered_report2*' -exec ./scripts/analyzer/upload.sh ${FOLDER}-phobos {} phobos \;

find out/ansible/lockbit/good/ -name 'report2*' -not -name '*.json' -exec mv {} {}.json \;
find out/ansible/lockbit/good/ -name 'report2*' -name '*.json' -exec sed -ri 's/([^\\])\\([^\\])/\1\\\\\2/g' {} \;
find out/ansible/lockbit/good/ -name 'report2*' -name '*.json' -exec python3 ./scripts/python/report-flatten-filter.py {} \;
find out/ansible/lockbit/good/ -name 'flattened_filtered_report2*' -exec ./scripts/analyzer/upload.sh ${FOLDER}-lockbit {} lockbit \;

find out/ansible/Ransomware.WannaCry/good/ -name 'report2*' -not -name '*.json' -exec mv {} {}.json \;
find out/ansible/Ransomware.WannaCry/good/ -name 'report2*' -name '*.json' -exec sed -ri 's/([^\\])\\([^\\])/\1\\\\\2/g' {} \;
find out/ansible/Ransomware.WannaCry/good/ -name 'report2*' -name '*.json' -exec python3 ./scripts/python/report-flatten-filter.py {} \;
find out/ansible/Ransomware.WannaCry/good/ -name 'flattened_filtered_report2*' -exec ./scripts/analyzer/upload.sh ${FOLDER}-wannacry {} wannacry \;

find out/ansible/Ransomware.Vipasana/good/ -name 'report2*' -not -name '*.json' -exec mv {} {}.json \;
find out/ansible/Ransomware.Vipasana/good/ -name 'report2*' -name '*.json' -exec sed -ri 's/([^\\])\\([^\\])/\1\\\\\2/g' {} \;
find out/ansible/Ransomware.Vipasana/good -name 'report2*' -name '*.json' -exec python3 ./scripts/python/report-flatten-filter.py {} \;
find out/ansible/Ransomware.Vipasana/good/ -name 'flattened_filtered_report2*' -exec ./scripts/analyzer/upload.sh ${FOLDER}-vipasana {} vipasana \;


curl -X POST http://192.168.2.222:5000/aggregator \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-phobos"

curl -X POST http://192.168.2.222:5000/aggregator \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-lockbit"

curl -X POST http://192.168.2.222:5000/aggregator \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-wannacry"

curl -X POST http://192.168.2.222:5000/aggregator \
	-H "api_key:$API_KEY" \
	-F "name_folder=${FOLDER}-vipasana"

