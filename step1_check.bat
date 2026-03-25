@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 0] Pre-flight Check
echo ============================================================
echo.

set PASS=1

echo [CMake]
cmake --version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: CMake not found. Install and add to PATH.
    set PASS=0
) else ( echo   OK )
echo.

echo [Python]
python --version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: Python not found. Install and add to PATH.
    set PASS=0
) else ( echo   OK )
echo.

echo [Git]
git --version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: Git not found. Install and add to PATH.
    set PASS=0
) else ( echo   OK )
echo.

echo [Visual Studio 2022 C++ Compiler]
where cl.exe >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   WARNING: cl.exe not found in PATH.
    echo            Run from VS2022 Developer Command Prompt, or
    echo            CMake will search for it automatically.
) else ( echo   OK )
echo.

if "%PASS%"=="1" (
    echo All checks passed. Proceed to next step.
) else (
    echo Some tools are missing. Fix the errors above and re-run.
)
echo.
pause