#!/bin/bash

# source variables (also used for ansible)
source variables.sh

# create variables for windows (remote)
#sed -r 's/(.*=.*)/set \1/; s/\$\{([^}]*)\}/%\1%/g' ${name_windows_env} > ${name_windows_env}


# Downloads

mkdir -p ${local_working_directory}/${local_ranflood_files_dir}
cd ${local_working_directory}/${local_ranflood_files_dir}

#if [[ ! -f ${ranflood_zip_win} ]]; then
#	echo "[Download] Downloading ranflood..."
#	curl -L -o ${name_ranflood_zip} ${ranflood_download}/${ranflood_version}/${ranflood_zip_win}
#else
#	echo "[Download] Ranflood already downloaded"
#fi

cd ${local_working_directory}


# Run ansible

ansible-playbook -i external_inventory full_playbook.yml --extra-vars "@ansible_variables.yml"