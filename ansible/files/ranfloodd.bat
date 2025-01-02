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