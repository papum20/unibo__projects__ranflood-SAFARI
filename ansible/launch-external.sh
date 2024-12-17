#!/bin/bash

# source variables (also used for ansible)
source variables.sh

# create variables for windows (remote)
sed -r 's/(.*=.*)/set \1/; s/\$\{([^}]*)\}/%\1%/g' ${name_windows_env} > ${name_windows_env}


ansible-playbook -i external_inventory full_playbook.yml --extra-vars "@ansible_variables.yml"