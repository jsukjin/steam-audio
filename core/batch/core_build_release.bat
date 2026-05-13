@echo off
cd /d "%~dp0.."
cmake --build _out --config Release --target core
if %errorlevel% neq 0 (
    echo Build Failed
    pause
    exit /b 1
)
echo Build Success
pause
