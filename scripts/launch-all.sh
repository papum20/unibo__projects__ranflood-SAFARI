#!/bin/bash

function usage() {
  echo "launch-all.sh: Launch the full SAFARI project (destroy and re-deploy with terraform, run with ansible)."
  echo "	Destroy is needed because the VMs, after infecting them (and disabling its network interfaces), would be hard to access and also dangerous, "
  echo "	but also in order to provision them again, and getting their new IPs."
  echo "Usage: $0"
  exit 1
}

dir_ansible=ansible/
dir_ansible_variables=${dir_ansible}variables/
dir_scripts=scripts/
dir_terraform=terraform/

out_terraform_filename=vm.txt

name_variables_ids=variables-vm-ids.generated.yml
name_variables_ips=variables-vm-ips.generated.yml

# Check path/required files
required_dirs=( \
	${dir_ansible} \
	${dir_scripts} \
	${dir_terraform} 
)

for file in "${required_dirs[@]}"; do
    if [[ ! -d $file ]]; then
		echo "directories ${required_dirs[@]} not found. Make sure to run this script from the project's root directory."
		usage
    fi
done



#
# Terraform
#

cd $dir_terraform

# clean previous VMs data
rm ${out_terraform_filename}

echo "[Terraform] Launching terraform"
terraform destroy -auto-approve
terraform apply -auto-approve

cd ..

# generate ansible variables
source ${dir_scripts}/read-vms.sh

{
  echo "vm_ids:"
  for id in "${vm_ids[@]}"; do
    echo "  - $id"
  done
} > "${dir_ansible_variables}/${name_variables_ids}"

{
  echo "vm_ips:"
  for ip in "${vm_ips[@]}"; do
	echo "  - $ip"
  done
} > "${dir_ansible_variables}/${name_variables_ips}"


#
# Ansible
#

echo "[Ansible] Launching ansible"
./${dir_scripts}launch-ansible.sh -y


