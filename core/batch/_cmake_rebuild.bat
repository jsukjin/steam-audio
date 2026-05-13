@echo off
cd /d "%~dp0.."
call cmake -B _out -G "Visual Studio 17 2022" -A x64
pause
