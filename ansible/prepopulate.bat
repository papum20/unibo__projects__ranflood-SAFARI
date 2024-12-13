@echo off
setlocal enabledelayedexpansion

:: Passo 1 a : Avvia il demone di Ranflood
start " " C:\path\to\ranfloodd C:\path\to\settings.ini

:: Passo 1 b : Aspetta qualche secondo in modo che il demone sia pronto
timeout /t 3 /nobreak

:: Passo 2: Avvia il task di flooding
C:\path\to\ranflood flood start random C:\path\to\target-folder

:: Passo 3: Usa il comando list del client per ottenere l ’ ID del task
C:\path\to\ranflood flood list > C:\path\to\task_list.log

:: Passo 4: Estrai l ’ ID del task dall ’ output del comando list
:: Estrai l ’ ultima riga
set "taskID="
for /f "tokens=* delims= " %%A in (C:\path\to\task_list.log) do (
set "lastLine=%%A"
)

:: Estrai l ’ ultimo toke , ovvero l ’ ID del task
for /f "tokens=3 delims=| " %%A in ("!lastLine!") do (
set "taskID=%%A"
)

:: Passo 5: Controlla lo spazio , se inferiore a 1 MB ferma il flooding usando l’ID
:: check_space
for /f "tokens=*" %%A in (’powershell -command "$drive=Get-PSDrive -Name C; $drive.Free"’) do (
	set "freeBytes=%%A"
)
set /a freeKB=!freeBytes!/1024

if !freeKB! geq 1024 (
	timeout /t 2 /nobreak
	goto check_space
)

C:\path\to\ranflood flood stop random %taskID%

:: Passo 7: Ferma il demone
taskkill /f /im ranfloodd.exe

endlocal