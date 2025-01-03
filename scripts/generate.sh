#!/bin/bash


# variables
dir_variables=variables/
variables=variables.generated.yml
variables_user=variables.sh
variables_external=variables_external.yml
variables_credentials_user=variables-credentials.secret.sh
variables_credentials=variables-credentials.generated.secret.yml
variables_vm_ids=variables-vm-ids.generated.yml
variables_vm_ips=variables-vm-ips.generated.yml
variables_vm_ids_user=variables-vm-ids.yml
variables_vm_ips_user=variables-vm-ips.yml

function usage() {
  echo "generate.sh: Automatically generate the required files, like variables."
  echo "	This command should be launched from the project's root directory."
  echo "Usage: ./scripts/generate.sh"
  exit 1
}


cd ansible/

# Check args

if [[ -f ${dir_variables}${variables_vm_ids_user} ]]; then
	variables_vm_ids=${variables_vm_ids_user}
fi

if [[ -f ${dir_variables}${variables_vm_ips_user} ]]; then
	variables_vm_ips=${variables_vm_ips_user}
fi

## Required files
required_files=( \
	"${dir_variables}${variables_external}" \
	"${dir_variables}${variables_credentials_user}" \
	"${dir_variables}${variables_user}" \
)

for file in "${required_files[@]}"; do
    if [[ ! -f $file ]]; then
		echo "$file not found."
        usage
    fi
done


# Set variables

set -a

# source variables (also used for ansible)
source ${dir_variables}${variables_user}
source ${dir_variables}${variables_credentials_user}


# create variables for ansible
## set with `:`, and use `'`
sed -r 's/([^=]*)=.*/\1: '\''${\1}'\''/g' ${dir_variables}${variables_user} | \
	## evaluate variables
 	envsubst > ${dir_variables}${variables}

sed -r 's/([^=]*)=.*/\1: '\''${\1}'\''/g' ${dir_variables}${variables_credentials_user} | \
	## evaluate variables
 	envsubst > ${dir_variables}${variables_credentials}

# create variables for scripts

## remote windows host
## set with `set` command; remove `"`, `'` wrapping variables values; replace comments using `::`
sed -r 's/(.*=.*)/set \1/; s/(.*)=["'\''](.*)["'\'']$/\1=\2/; s/^#(.*)/::\1/g' ${dir_variables}${variables_user} | \
	envsubst > ${local_working_directory}${local_path_files_transfer}/${name_env_windows}

## remote windows host, wsl
cp ${dir_variables}${variables_user} ${local_working_directory}${local_path_files_transfer}/${name_env_linux}


