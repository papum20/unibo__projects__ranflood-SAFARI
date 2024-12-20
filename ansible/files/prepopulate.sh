# NOTE: for ranflood commands, you need to use windows paths (e.g. settings, target dir),
# while running in windows wsl


# Source variables
set -a
source ./variables.sh

mkdir $ranflood_random_target_dir_linux
path_tasks_list=${remote_working_directory_linux}tasks_list.log

# Start daemon
${path_ranfloodd_linux} ${path_settings_ini_win} &
pid_daemon=$!
sleep 3

# Flood
${path_ranflood_linux} flood start random ${ranflood_random_target_dir}

# Extract task ID (last token) to stop the flooding later
${path_ranflood_linux} flood list > ${path_tasks_list}
taskID=$(tail -1 ${path_tasks_list} | cut -d'|' -f3)
echo "Flood task id is $taskID"

# Passo 5: fill until target dir takes up enough space
function space_used() {
	du -s -BK ${ranflood_random_target_dir_linux} | sed -r 's/([0-9]+).*/\1/'
}

while [[ space_used -lt ranflood_random_remaining_space_kb ]]; do
	s=$(space_used)
	echo "Space used in target dir: $(space_used) KB"
	echo "$s"
	echo "$ranflood_random_remaining_space_kb"
	echo [[ space_used -lt ranflood_random_remaining_space_kb ]]
	sleep 1
done

echo "Space used in target dir: $(space_used) KB"

${path_ranflood_linux} flood stop random ${taskID}

# Passo 7: Stop daemon
kill pid_daemon
