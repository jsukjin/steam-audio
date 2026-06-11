@echo off

set VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe

for /f "usebackq delims=" %%i in (`
    "%VSWHERE%" -latest -products * -property installationVersion
`) do set VS_VERSION=%%i

set VS_GENERATOR=

echo %VS_VERSION% | findstr /b "18." >nul
if not errorlevel 1 set VS_GENERATOR=Visual Studio 18 2026

echo %VS_VERSION% | findstr /b "17." >nul
if not errorlevel 1 set VS_GENERATOR=Visual Studio 17 2022

echo %VS_VERSION% | findstr /b "16." >nul
if not errorlevel 1 set VS_GENERATOR=Visual Studio 16 2019

echo Detected: %VS_GENERATOR%

powershell -ExecutionPolicy Bypass ^
"(Get-Content get_dependencies.py) -replace 'Visual Studio 17 2022','%VS_GENERATOR%' | Set-Content get_dependencies.py"

powershell -ExecutionPolicy Bypass ^
"(Get-Content build.py) -replace 'Visual Studio 17 2022','%VS_GENERATOR%' | Set-Content build.py"