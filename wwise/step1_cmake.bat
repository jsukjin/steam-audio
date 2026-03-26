@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 1] CMake Configure - Generate Build Files
echo ============================================================
echo.
echo  CMake will scan the project configuration
echo  and generate the build files.
echo.
echo  Target: Steam Audio Wwise Plugin
echo  Version: 4.8.1
echo  Platform: Windows (VS2022, x64)
echo  Configuration: Release
echo.

set WWISE_DIR=%~dp0
set OUT_DIR=%WWISE_DIR%_out

echo  Source  : %WWISE_DIR:~0,-1%
echo  Output  : %OUT_DIR%
echo.

echo [Removing existing _out folder to avoid CMakeCache conflicts]
if exist "%OUT_DIR%" (
    echo   Deleting _out ...
    rmdir /s /q "%OUT_DIR%"
    echo   Done
) else ( echo   No _out folder, skipping )

echo.
echo [Creating output directory]
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

echo.
echo [Running CMake configure]
set SRC=%WWISE_DIR:~0,-1%
set OUT=%OUT_DIR:~0,-1%

REM CMake configuration for Wwise plugin
REM Additional options can be added here:
REM   -DSTEAMAUDIOWWISE_BUILD_DOCS=ON     - Build documentation
REM   -DCMAKE_BUILD_TYPE=Debug            - Debug build instead of Release

cd /d "%OUT_DIR%"
cmake -S "%SRC%" -B "%OUT_DIR%" -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  FAILED: CMake configure failed.
    echo  Check the error messages above.
    echo  Verify that CMake and Visual Studio 17 2022 (or later) are installed.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Success!
echo.
echo  Build files generated in: %OUT_DIR%
echo.
echo  Next steps:
echo    1. Run step2_build.bat to compile
echo    2. Or build from command line:
echo       cmake --build "%OUT_DIR%" --config Release
echo ============================================================
echo.
pause