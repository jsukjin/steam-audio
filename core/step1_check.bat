@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================================
echo  [STEP 1] Pre-flight Check
echo ============================================================
echo.
set PASS=1

:: [CMake] Check
echo [CMake]
cmake --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo    ERROR: CMake not found.
    set PASS=0
) else ( echo    OK )
echo.

:: [Python] Check
echo [Python]
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo    ERROR: Python not found.
    set PASS=0
) else ( echo    OK )
echo.

:: [Git] Check
echo [Git]
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo    ERROR: Git not found.
    set PASS=0
) else ( echo    OK )
echo.

:: [Visual Studio 2022] Check
echo [Visual Studio 2022 C++ Compiler]
set "VS_PATH="
for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
    set "VS_PATH=%%i"
)

if not defined VS_PATH (
    echo    ERROR: Visual Studio 2022 C++ Build Tools not found.
    set PASS=0
    goto vs_done
)

echo    Found VS: !VS_PATH!
set "VCVARS=!VS_PATH!\VC\Auxiliary\Build\vcvars64.bat"
if exist "!VCVARS!" (
    call "!VCVARS!" >nul 2>&1
    echo    OK (Environment initialized)
) else (
    echo    ERROR: vcvars64.bat not found. Check C++ workload.
    set PASS=0
)

:vs_done
echo.

:: [Final Result]
if "%PASS%"=="1" (
    echo ============================================================
    echo All checks passed. Next: step2_patch.bat
    echo ============================================================
) else (
    echo ============================================================
    echo Some tools are missing. Fix the errors above and re-run.
    echo ============================================================
)
echo.
pause