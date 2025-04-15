::/******************************************************************************
:: * Copyright 2025 (C) by Daniele D'Ugo <danieledugo1@gmail.com>               *
:: *                                                                            *
:: * This program is free software; you can redistribute it and/or modify       *
:: * it under the terms of the GNU Library General Public License as            *
:: * published by the Free Software Foundation; either version 2 of the         *
:: * License, or (at your option) any later version.                            *
:: *                                                                            *
:: * This program is distributed in the hope that it will be useful,            *
:: * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
:: * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
:: * GNU General Public License for more details.                               *
:: *                                                                            *
:: * You should have received a copy of the GNU Library General Public          *
:: * License along with this program; if not, write to the                      *
:: * Free Software Foundation, Inc.,                                            *
:: * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                  *
:: *                                                                            *
:: * For details about the authors of this software, see the AUTHORS file.      *
:: ******************************************************************************/


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