#!/bin/bash


# timestamp, can be used as "unique" id
timestamp=$(date +'%Y%m%d-%H_%M_%S')


# Script

# for downloading binaries
ranflood_download=https://github.com/Flooding-against-Ransomware/ranflood/releases/download/v.0.7-beta/ranflood-v.0.7-beta_Windows.zip
ransomware_download_link=https://github.com/Flooding-against-Ransomware/ranflood/blob/master/resources/ransomwares/Ransomware.WannaCry/Ransomware.WannaCry.zip


# Ansible

local_working_directory="${PWD}/"

# subdirectory of `local_working_directory` containing ranflood files to transfer
local_ranflood_files_dir="files/"

# where all files will be transferred
remote_working_directory_win='C:\Users\'
remote_working_directory_linux=/mnt/c/Users/


# Files to transfer (ansible)

# avoid transfers if already exists
transfer_force=true

dir_variables=variables/

name_internal_playbook=internal_playbook.yml
name_internal_inventory=internal_inventory
name_internal_variables=internal_inventory
name_ansible_variables=variables.generated.yml
name_ansible_variables_internal=variables_internal.yml


# Files to transfer (ranflood, ransomwares)

name_filechecker_jar=filechecker.jar
name_ranflood=ranflood.exe
name_ranfloodd=ranfloodd.exe
name_ranflood_bat=ranflood.bat
name_ranfloodd_bat=ranfloodd.bat
name_ranflood_jar=ranflood.jar
name_ranfloodd_jar=ranfloodd.jar
#name_ranflood_zip=ranflood-v.0.6-beta_Windows.zip
name_ranflood_zip=ranflood-v.0.6-beta_Windows_client.zip
name_ransomware=Ransomware.WannaCry
name_ransomware_zip=${name_ransomware}.zip

name_settings_ini=settings.ini

name_vcruntime140_1_dll=vcruntime140_1.dll

## for scripts to execute on the remote hosts
name_prepopulate_script=prepopulate.sh
name_prepopulate_script_win=prepopulate.bat
name_env_windows=variables.generated.bat
name_env_linux=variables.generated.sh


# Config, execution

path_ranflood_dir_win='C:\Program Files\Ranflood\'
path_ranflood_win="${path_ranflood_dir_win}${name_ranflood}"
path_ranfloodd_win="${path_ranflood_dir_win}${name_ranfloodd}"
path_ranflood_bat="${remote_working_directory_win}${name_ranflood_bat}"
path_ranfloodd_bat="${remote_working_directory_win}${name_ranfloodd_bat}"
path_ranflood_jar_win="${path_ranflood_dir_win}${name_ranflood_jar}"
path_ranfloodd_jar_win="${path_ranflood_dir_win}${name_ranfloodd_jar}"
path_ransomware_win="${remote_working_directory_win}${name_ransomware}"
path_settings_ini_win="${remote_working_directory_win}${name_settings_ini}"

path_ranflood_dir_linux='/mnt/c/Program Files/Ranflood/'
path_ranflood_linux="${path_ranflood_dir_linux}${name_ranflood}"
path_ranfloodd_linux="${path_ranflood_dir_linux}${name_ranfloodd}"
path_ranflood_jar_linux="${path_ranflood_dir_linux}${name_ranflood_jar}"
path_ranfloodd_jar_linux="${path_ranflood_dir_linux}${name_ranfloodd_jar}"
path_ransomware_linux="${remote_working_directory_linux}${name_ransomware}"
path_settings_ini_linux="${remote_working_directory_linux}${name_settings_ini}"

# where output of internal playbook is saved
path_log_linux="${remote_working_directory_linux}log${timestamp}.txt"
# log of filechecker restore command
path_log_filechecker="/home/checker/log${timestamp}.txt"
path_log_internal_daemon="${remote_working_directory_win}log_daemon${timestamp}.txt"

# seconds for which to run ranflood random to prepopulate the disk
ranflood_random_duration=3
# stop prepopulating with random when less of KB of free space is available
ranflood_random_remaining_space_kb=1000000

# target dir to prepopulate with random files (through prepopulate.sh)
ranflood_random_target_dir='C:\Users\IEUser\Documents\'
ranflood_random_target_dir_linux='/mnt/c/Users/IEUser/Documents/'

