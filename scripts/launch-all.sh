#!/bin/bash

function usage() {
  echo "launch-all.sh: Launch the full SAFARI project (destroy and re-deploy with terraform, run with ansible)."
  echo "	Destroy is needed because the VMs, after infecting them (and disabling its network interfaces), would be hard to access and also dangerous, "
  echo "	but also in order to provision them again, and getting their new IPs."
  echo "Usage: $0 [--c|-checker] [-d|--delete] [-h|--help]"
  echo "  -c, --checker: Provision and run the filechecker VM."
  echo "  -d, --delete: Delete the VMs first (useful to re-run provisioning, in case VMs IPs and IDs weren't saved)."
  echo "  -h, --help: Show this help message."
  exit 1
}

dir_ansible=ansible/
dir_ansible_variables=${dir_ansible}variables/
dir_terraform=terraform/
dir_current=$(pwd)
script_ansible=launch-ansible.sh

out_terraform_filename=vm.txt

name_variables_ids=variables-vm-ids.generated.yml
name_variables_ips=variables-vm-ips.generated.yml


#
# ARGS
#

mode=flood
terraform_delete=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c|--checker)
      dir_ansible=${dir_ansible}checker/
      dir_ansible_variables=${dir_ansible}
      dir_terraform=terraform/checker/
      script_ansible=launch-ansible-checker.sh
      mode=checker
      shift
      ;;
    -d|--delete)
      terraform_delete=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Check path/required files
required_dirs=( \
	${dir_ansible} \
	scripts \
	${dir_terraform} 
)

for file in "${required_dirs[@]}"; do
    if [[ ! -d $file ]]; then
		echo "directories ${required_dirs[@]} not found. Make sure to run this script from the project's root directory."
		usage
    fi
done

if [[ $mode == "flood" ]]; then 
  echo "[Script] Launching in flood mode"
else
  echo "[Script] Launching in checker mode"
fi



#
# Terraform
#

cd $dir_terraform


echo "[Terraform] Launching terraform"

if [[ $terraform_delete == true ]]; then
  # clean previous VMs data
  rm ${out_terraform_filename}
  
  echo "[Terraform] Deleting previous VMs"
  terraform destroy -auto-approve
fi

terraform apply -auto-approve

cd $dir_current

# generate ansible variables
source scripts/read-vms.sh ${dir_terraform}

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
"./scripts/${script_ansible}" -y


