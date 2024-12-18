#!/bin/bash

set -a

# source variables (also used for ansible)
source variables.sh


# create variables for ansible
# set with `:`, and use `'`
sed -r 's/([^=]*)=.*/\1: '\''${\1}'\''/g' variables.sh | \
	# evaluate variables
 	envsubst > variables.yml

# create variables for windows (remote)
# set with `set` command; remove `"`, `'` wrapping variables values; replace comments using `::`
sed -r 's/(.*=.*)/set \1/; s/(.*)=["'\''](.*)["'\'']$/\1=\2/; s/^#(.*)/::\1/g' variables.sh | \
	envsubst > ${local_working_directory}${local_ranflood_files_dir}${name_env_windows}

# create variables for linux (remote)
cp variables.sh ${local_working_directory}${local_ranflood_files_dir}${name_env_linux}


# Downloads

mkdir -p ${local_working_directory}/${local_ranflood_files_dir}
cd ${local_working_directory}/${local_ranflood_files_dir}

if [[ ! -f ${ranflood_zip_win} ]]; then
	echo "[Download] Downloading ranflood..."
	curl -L -o ${name_ranflood_zip} ${ranflood_download}/${ranflood_version}/${ranflood_zip_win}
else
	echo "[Download] Ranflood already downloaded"
fi

cd ${local_working_directory}


# Run ansible

ansible-playbook -i external_inventory full_playbook.yml \
	--extra-vars "@variables.yml" \
	--extra-vars "@variables_vm.yml"
