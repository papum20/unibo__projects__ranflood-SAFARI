::!/bin/bash


:: timestamp, can be used as "unique" id
set timestamp=$(date +'%Y%m%d-%H_%M_%S')


:: Script

:: for downloading binaries
set ranflood_download=https://github.com/Flooding-against-Ransomware/ranflood/releases/download/v.0.7-beta/ranflood-v.0.7-beta_Windows.zip
set ransomware_download_link=https://github.com/Flooding-against-Ransomware/ranflood/blob/master/resources/ransomwares/Ransomware.WannaCry/Ransomware.WannaCry.zip


:: Ansible

set local_working_directory=/home/papum/programm/unibo/projects/SAFARI/ansible/

:: subdirectory of `local_working_directory` containing ranflood files to transfer
set local_ranflood_files_dir=files/

:: where all files will be transferred
set remote_working_directory_win=C:\Users\
set remote_working_directory_linux=/mnt/c/Users/


:: Files to transfer (ansible)

:: avoid transfers if already exists
set transfer_force=true

set dir_variables=variables/

set name_internal_playbook=internal_playbook.yml
set name_internal_inventory=internal_inventory
set name_internal_variables=internal_inventory
set name_ansible_variables=variables.generated.yml
set name_ansible_variables_internal=variables_internal.yml


:: Files to transfer (ranflood, ransomwares)

set name_filechecker_jar=filechecker.jar
set name_ranflood=ranflood.exe
set name_ranfloodd=ranfloodd.exe
set name_ranflood_bat=ranflood.bat
set name_ranfloodd_bat=ranfloodd.bat
set name_ranflood_jar=ranflood.jar
set name_ranfloodd_jar=ranfloodd.jar
set #name_ranflood_zip=ranflood-v.0.6-beta_Windows.zip
set name_ranflood_zip=ranflood-v.0.6-beta_Windows_client.zip
set name_ransomware=Ransomware.WannaCry
set name_ransomware_zip=Ransomware.WannaCry.zip

set name_settings_ini=settings.ini

set name_vcruntime140_1_dll=vcruntime140_1.dll

::# for scripts to execute on the remote hosts
set name_prepopulate_script=prepopulate.sh
set name_prepopulate_script_win=prepopulate.bat
set name_env_windows=variables.generated.bat
set name_env_linux=variables.generated.sh


:: Config, execution

set path_ranflood_dir_win=C:\Program Files\Ranflood\
set path_ranflood_win=C:\Program Files\Ranflood\ranflood.exe
set path_ranfloodd_win=C:\Program Files\Ranflood\ranfloodd.exe
set path_ranflood_bat=C:\Users\ranflood.bat
set path_ranfloodd_bat=C:\Users\ranfloodd.bat
set path_ranflood_jar_win=C:\Program Files\Ranflood\ranflood.jar
set path_ranfloodd_jar_win=C:\Program Files\Ranflood\ranfloodd.jar
set path_ransomware_win=C:\Users\Ransomware.WannaCry
set path_settings_ini_win=C:\Users\settings.ini

set path_ranflood_dir_linux=/mnt/c/Program Files/Ranflood/
set path_ranflood_linux=/mnt/c/Program Files/Ranflood/ranflood.exe
set path_ranfloodd_linux=/mnt/c/Program Files/Ranflood/ranfloodd.exe
set path_ranflood_jar_linux=/mnt/c/Program Files/Ranflood/ranflood.jar
set path_ranfloodd_jar_linux=/mnt/c/Program Files/Ranflood/ranfloodd.jar
set path_ransomware_linux=/mnt/c/Users/Ransomware.WannaCry
set path_settings_ini_linux=/mnt/c/Users/settings.ini

:: where output of internal playbook is saved
set path_log_linux=/mnt/c/Users/log20250103-11_20_22.txt
:: log of filechecker restore command
set path_log_filechecker=/home/checker/log20250103-11_20_22.txt
set path_log_internal_daemon=C:\Users\log_daemon20250103-11_20_22.txt

:: seconds for which to run ranflood random to prepopulate the disk
set ranflood_random_duration=3
:: stop prepopulating with random when less of KB of free space is available
set ranflood_random_remaining_space_kb=1000000

:: target dir to prepopulate with random files (through prepopulate.sh)
set ranflood_random_target_dir=C:\Users\IEUser\Documents\
set ranflood_random_target_dir_linux=/mnt/c/Users/IEUser/Documents/

