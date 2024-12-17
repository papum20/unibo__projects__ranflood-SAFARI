#!/bin/bash

set -a


local_working_directory=$(pwd)

# subdirectory of `local_working_directory` containing ranflood files to transfer
local_ranflood_files_dir="ranflood/"

# where all files will be transferred
remote_working_directory='C:\Users\'
#remote_linux_user_directory: /mnt/c/Users/


# Files to transfer (ansible)

name_internal_playbook=internal_playbook.yml
name_internal_inventory=internal_inventory
name_ansible_variables=ansible_variables.yml


# Files to transfer (ranflood, ransomwares)

name_ranflood=ranflood.exe
name_ranfloodd=ranfloodd.exe
name_ransomware_zip=Ransomware.WannaCry.zip

name_prepopulate_script=prepopulate.bat
name_windows_env=variables.bat
name_settings_ini=settings.ini


# Config, execution

path_ranflood="${remote_working_directory}${name_ranflooddd}"
path_ranfloodd="${remote_working_directory}${name_ranflood}"
path_ransomware="${remote_working_directory}${name_ransomware}"
path_settings_ini="${remote_working_directory}${name_settings_ini}"


