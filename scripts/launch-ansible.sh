#!/bin/bash

dir_ansible=ansible

# variables
dir_variables=variables/
variables=variables.sh
variables_external=variables_external.yml
variables_credentials=variables-credentials.generated.secret.yml
variables_vm_ids=variables-vm-ids.generated.yml
variables_vm_ips=variables-vm-ips.generated.yml
variables_vm_ids_user=variables-vm-ids.yml
variables_vm_ips_user=variables-vm-ips.yml

function usage() {
	echo "launch-ansible: Launch the ansible playbooks."
	echo "	${variables_vm_ids}, ${variables_vm_ips} can be automatically generated by scripts/launch-all.sh, from the terraform output;"
	echo "	however, if ${variables_vm_ids_user}, ${variables_vm_ips_user} are found, they are used instead."
	echo "Usage: $0 [-y]"
	echo "  -y: skip warning"
	echo ""
	echo "  Warning: this script will download a zipped ransomware."
	exit 1
}


# Check current dir

if [[ ! -d ${dir_ansible} ]]; then
	echo "Directory ${dir_ansible} not found. Make sure to run this command from the project's root directory."
	usage
else
	cd ${dir_ansible}
	pwd
fi

# Check args

if [[ -f ${dir_variables}${variables_vm_ids_user} ]]; then
	variables_vm_ids=${variables_vm_ids_user}
fi

if [[ -f ${dir_variables}${variables_vm_ips_user} ]]; then
	variables_vm_ips=${variables_vm_ips_user}
fi

## Required files
required_files=( \
	"full_playbook.yml" \
	"internal_inventory" \
	"internal_playbook.yml" \
	"${dir_variables}${variables_external}"
	"${dir_variables}variables-credentials.secret.sh" \
	"${dir_variables}${variables}" \
)

for file in "${required_files[@]}"; do
    if [[ ! -f $file ]]; then
		echo "$file not found."
        usage
    fi
done

## Args

skip_warning=false
while getopts "y" opt; do
    case $opt in
        y)
            skip_warning=true
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
			usage
            exit 1
            ;;
    esac
done

# Ask user if they want to continue with the download
if ! $skip_warning; then
    read -p "Warning: This script will download a ransomware. Do you want to continue? (y/n): " choice
    case "$choice" in 
      y|Y ) echo "Continuing...";;
      n|N ) echo "Exiting..."; exit 0;;
      * ) echo "Invalid choice."; usage;;
    esac
fi


# Set variables

set -a

# source variables (also used for ansible)
source ${dir_variables}${variables}
source ${dir_variables}variables-credentials.secret.sh


# create variables for ansible
## set with `:`, and use `'`
sed -r 's/([^=]*)=.*/\1: '\''${\1}'\''/g' ${dir_variables}${variables} | \
	## evaluate variables
 	envsubst > ${dir_variables}variables.generated.yml

sed -r 's/([^=]*)=.*/\1: '\''${\1}'\''/g' ${dir_variables}variables-credentials.secret.sh | \
	## evaluate variables
 	envsubst > ${dir_variables}variables-credentials.generated.secret.yml

# create variables for scripts

## remote windows host
## set with `set` command; remove `"`, `'` wrapping variables values; replace comments using `::`
sed -r 's/(.*=.*)/set \1/; s/(.*)=["'\''](.*)["'\'']$/\1=\2/; s/^#(.*)/::\1/g' ${dir_variables}${variables} | \
	envsubst > ${local_working_directory}${local_ranflood_files_dir}${name_env_windows}

## remote windows host, wsl
cp ${dir_variables}${variables} ${local_working_directory}${local_ranflood_files_dir}${name_env_linux}


# Downloads

mkdir -p ${local_working_directory}/${local_ranflood_files_dir}
cd ${local_working_directory}/${local_ranflood_files_dir}

if [[ ! -f ${name_ranflood_zip} ]]; then
	echo "[Download] Downloading ranflood..."
	curl -L -o ${name_ranflood_zip} ${ranflood_download}
else
	echo "[Download] ${name_ranflood_zip} already downloaded"
fi
if [[ ! -f ${name_ransomware_zip} ]]; then
	echo "[Download] Downloading ${name_ransomware_zip}..."
	curl -L -o ${name_ransomware_zip} ${ransomware_download_link}
else
	echo "[Download] ${name_ransomware_zip} already downloaded"
fi

cd ${local_working_directory}


# Run ansible

ansible-playbook -i external_inventory full_playbook.yml \
	--extra-vars "@${dir_variables}${name_ansible_variables}" \
	--extra-vars "@${dir_variables}${variables_external}" \
	--extra-vars "@${dir_variables}${variables_credentials}" \
	--extra-vars "@${dir_variables}${variables_vm_ids}" \
	--extra-vars "@${dir_variables}${variables_vm_ips}"