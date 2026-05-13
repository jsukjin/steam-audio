@echo off
cd /d "%~dp0.."
_out\src\test\Release\phonon_test.exe "[memory]"
pause
