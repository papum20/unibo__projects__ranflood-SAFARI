::@echo off
setlocal enabledelayedexpansion

:: Source variables
call .\variables.bat

mkdir %ranflood_target_dir%
set path_tasks_list=%remote_working_directory%tasks_list.log

:: Passo 1 : Start daemon
call start "" %path_ranflood_win% %path_settings_ini_win%
call timeout /t 3 /nobreak

:: Passo 2: Avvia il task di flooding
call %path_ranflood_win% flood start random 

:: Passo 3: Usa il comando list del client per ottenere l ’ ID del task
call %path_ranflood_win% flood list > %path_tasks_list%

:: Passo 4: Estrai l ’ ID del task dall ’ output del comando list
:: Estrai l ’ ultima riga
call set "taskID="
for /f "tokens=* delims= " %%A in (%path_tasks_list%) do (
	set "lastLine=%%A"
)

:: Extract task ID (last token) to stop the flooding later
for /f "tokens=3 delims=| " %%A in ("!lastLine!") do (
	set "taskID=%%A"
)

:: Passo 5: fill until target dir takes up enough space
:check_space
for /f "tokens=*" %%A in ('wsl -e sh -c "du -s -BK %ranflood_target_dir% | sed -r 's/([0-9]+).*/\1/'"') do (
	set "usedKB=%%A"
)

if !usedKB! geq %ranflood_random_remaining_space_kb% (
	timeout /t 1 /nobreak
	goto check_space
)

call %path_ranflood_win% flood stop random %taskID%

:: Passo 7: Stop daemon
taskkill /f /im %path_ranfloodd_win%

endlocal