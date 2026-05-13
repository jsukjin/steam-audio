@echo off
cd /d "%~dp0.."
python build\get_itest_deps.py --dep portaudio
pause
