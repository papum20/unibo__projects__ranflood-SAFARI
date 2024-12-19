#!/bin/bash



# Script

# for downloading binaries
ranflood_download=https://github.com/Flooding-against-Ransomware/ranflood/releases/download/
ranflood_version=v.0.7-beta
ranflood_zip_win=ranflood-v.0.7-beta_Windows.zip


# Ansible

local_working_directory="${PWD}/"

# subdirectory of `local_working_directory` containing ranflood files to transfer
local_ranflood_files_dir="files/"

# where all files will be transferred
remote_working_directory_win='C:\Users\'
remote_working_directory_linux=/mnt/c/Users/


# Files to transfer (ansible)

# avoid transfers if already exists
transfer_force=false

name_internal_playbook=internal_playbook.yml
name_internal_inventory=internal_inventory
name_ansible_variables=variables.yml


# Files to transfer (ranflood, ransomwares)

name_ranflood=ranflood.exe
name_ranfloodd=ranfloodd.exe
name_ranflood_zip=ranflood-v.0.7-beta_Windows.zip
name_ransomware_zip=Ransomware.WannaCry.zip

name_prepopulate_script=prepopulate.sh
name_prepopulate_script_win=prepopulate.bat
name_settings_ini=settings.ini
name_env_windows=variables.bat
name_env_linux=variables.sh


# Config, execution

#path_ranflood_win="${remote_working_directory_win}${name_ranfloodd}"
#path_ranfloodd_win="${remote_working_directory_win}${name_ranflood}"
#path_ransomware_win="${remote_working_directory_win}${name_ransomware}"
#path_settings_ini_win="${remote_working_directory_win}${name_settings_ini}"

path_ranflood_dir_win='C:/ranflood-exe-0.5.9/'
path_ranflood_win="${path_ranflood_dir}${name_ranflood}"
path_ranfloodd_win="${path_ranflood_dir}${name_ranflood}"
path_ransomware_win="${remote_working_directory_win}${name_ransomware}"
path_settings_ini_win="${remote_working_directory_win}${name_settings_ini}"

#path_ranflood_linux="${remote_working_directory_linux}${name_ranflood}"
#path_ranfloodd_linux="${remote_working_directory_linux}${name_ranfloodd}"
#path_ransomware_linux="${remote_working_directory_linux}${name_ransomware}"
#path_settings_ini_linux="${remote_working_directory_linux}${name_settings_ini}"

path_ranflood_dir_linux=/mnt/c/ranflood-exe-0.5.9/
path_ranflood_linux="${path_ranflood_dir_linux}${name_ranflood}"
path_ranfloodd_linux="${path_ranflood_dir_linux}${name_ranfloodd}"
path_ransomware_linux="${remote_working_directory_linux}${name_ransomware}"
path_settings_ini_linux="${remote_working_directory_linux}${name_settings_ini}"

# seconds for which to run ranflood random to prepopulate the disk
ranflood_random_duration=3
# stop prepopulating with random when less of KB of free space is available
ranflood_random_remaining_space_kb=1000000

ranflood_strategy=random
# seconds between the start of ransomware and ranflood (client)
ranflood_start_delay=60
ranflood_target_dir='C:\Users\IEUser\Documents\'
ranflood_target_dir_linux='/mnt/c/Users/IEUser/Documents/'

