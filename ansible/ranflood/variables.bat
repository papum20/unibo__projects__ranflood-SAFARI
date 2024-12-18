::!/bin/bash



:: Script

:: for downloading binaries
set ranflood_download=https://github.com/Flooding-against-Ransomware/ranflood/releases/download/
set ranflood_version=v.0.7-beta
set ranflood_zip_win=ranflood-v.0.7-beta_Windows.zip


:: Ansible

set local_working_directory=/home/papum/programm/unibo/projects/SAFARI/ansible/

:: subdirectory of `local_working_directory` containing ranflood files to transfer
set local_ranflood_files_dir=ranflood/

:: where all files will be transferred
set remote_working_directory_win=C:\Users\
set remote_working_directory_linux=/mnt/c/Users/


:: Files to transfer (ansible)

:: avoid transfers if already exists
set transfer_force=false

set name_internal_playbook=internal_playbook.yml
set name_internal_inventory=internal_inventory
set name_ansible_variables=variables.yml


:: Files to transfer (ranflood, ransomwares)

set name_ranflood=ranflood.exe
set name_ranfloodd=ranfloodd.exe
set name_ranflood_zip=ranflood-v.0.7-beta_Windows.zip
set name_ransomware_zip=Ransomware.WannaCry.zip

set name_prepopulate_script=prepopulate.sh
set name_prepopulate_script_win=prepopulate.bat
set name_settings_ini=settings.ini
set name_env_windows=variables.bat
set name_env_linux=variables.sh


:: Config, execution

set #path_ranflood_win=C:\Users\ranfloodd.exe
set #path_ranfloodd_win=C:\Users\ranflood.exe
set #path_ransomware_win=C:\Users\
set #path_settings_ini_win=C:\Users\settings.ini

set path_ranflood_dir_win=C:/ranflood-exe-0.5.9/
set path_ranflood_win=ranflood.exe
set path_ranfloodd_win=ranflood.exe
set path_ransomware_win=C:\Users\
set path_settings_ini_win=C:\Users\settings.ini

set #path_ranflood_linux=/mnt/c/Users/ranflood.exe
set #path_ranfloodd_linux=/mnt/c/Users/ranfloodd.exe
set #path_ransomware_linux=/mnt/c/Users/
set #path_settings_ini_linux=/mnt/c/Users/settings.ini

set path_ranflood_dir_linux=/mnt/c/ranflood-exe-0.5.9/
set path_ranflood_linux=/mnt/c/ranflood-exe-0.5.9/ranflood.exe
set path_ranfloodd_linux=/mnt/c/ranflood-exe-0.5.9/ranfloodd.exe
set path_ransomware_linux=/mnt/c/Users/
set path_settings_ini_linux=/mnt/c/Users/settings.ini

:: seconds for which to run ranflood random to prepopulate the disk
set ranflood_random_duration=3
:: stop prepopulating with random when less of KB of free space is available
set ranflood_random_remaining_space_kb=1000000

set ranflood_strategy=random
:: seconds between the start of ransomware and ranflood (client)
set ranflood_start_delay=60
set ranflood_target_dir=C:\Users\IEUser\Documents\
set ranflood_target_dir_linux=/mnt/c/Users/IEUser/Documents/

