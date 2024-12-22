::!/bin/bash


:: timestamp, can be used as "unique" id
set timestamp=$(date +'%Y%m%d-%H_%M_%S')


:: Script

:: for downloading binaries
set ranflood_download=https://github.com/Flooding-against-Ransomware/ranflood/releases/download/v.0.7-beta/ranflood-v.0.7-beta_Windows.zip
set ransomware_download_link=https://github.com/Flooding-against-Ransomware/ranflood/blob/master/resources/ransomwares/Ransomware.WannaCry/Ransomware.WannaCry.zip


:: Ansible

set local_working_directory=/home/danie/programm/unibo/projects/SAFARI/ansible/

:: subdirectory of `local_working_directory` containing ranflood files to transfer
set local_ranflood_files_dir=files/

:: where all files will be transferred
set remote_working_directory_win=C:\Users\
set remote_working_directory_linux=/mnt/c/Users/


:: Files to transfer (ansible)

:: avoid transfers if already exists
set transfer_force=false

set dir_variables=variables/

set name_internal_playbook=internal_playbook.yml
set name_internal_inventory=internal_inventory
set name_internal_variables=internal_inventory
set name_ansible_variables=variables.generated.yml
set name_ansible_variables_internal=variables_internal.yml


:: Files to transfer (ranflood, ransomwares)

set name_ranflood=ranflood.exe
set name_ranfloodd=ranfloodd.exe
set name_ranflood_zip=ranflood-v.0.7-beta_Windows.zip
set name_ransomware=Ransomware.WannaCry
set name_ransomware_zip=Ransomware.WannaCry.zip

set name_settings_ini=settings.ini

::# for scripts to execute on the remote hosts
set name_prepopulate_script=prepopulate.sh
set name_prepopulate_script_win=prepopulate.bat
set name_env_windows=variables.generated.bat
set name_env_linux=variables.generated.sh


:: Config, execution

set path_ranflood_dir_win=C:/Program Files/Ranflood/
set path_ranflood_win=ranflood.exe
set path_ranfloodd_win=ranflood.exe
set path_ransomware_win=C:\Users\Ransomware.WannaCry
set path_settings_ini_win=C:\Users\settings.ini

set path_ranflood_dir_linux=/mnt/c/Program Files/Ranflood/
set path_ranflood_linux=/mnt/c/Program Files/Ranflood/ranflood.exe
set path_ranfloodd_linux=/mnt/c/Program Files/Ranflood/ranfloodd.exe
set path_ransomware_linux=/mnt/c/Users/Ransomware.WannaCry
set path_settings_ini_linux=/mnt/c/Users/settings.ini

:: where output of internal playbook is saved
set path_log_linux=/mnt/c/Users/log20241222-15_42_21.txt

:: seconds for which to run ranflood random to prepopulate the disk
set ranflood_random_duration=3
:: stop prepopulating with random when less of KB of free space is available
set ranflood_random_remaining_space_kb=1000000

:: target dir to prepopulate with random files (through prepopulate.sh)
set ranflood_random_target_dir=C:\Users\IEUser\Documents\
set ranflood_random_target_dir_linux=/mnt/c/Users/IEUser/Documents/

