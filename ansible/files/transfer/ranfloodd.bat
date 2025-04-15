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


@echo off
setlocal


:: required arguments: JVM memory, ranfloodd args
if "%~1"=="" goto usage
if "%~2"=="" goto usage


set JVM_MEMORY=%1
set SETTINGS_INI=%2
shift

echo %*

java -Xmx%JVM_MEMORY% -jar "C:\Program Files\Ranflood\ranfloodd.jar" %SETTINGS_INI%
goto end

:usage
echo Usage: ranfloodd.bat ^<JVM memory^> ^<ranfloodd settings_ini^>
echo Example: ranfloodd.bat 3G settings.ini
goto end

:end
endlocal