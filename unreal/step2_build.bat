@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 2] CMake Build - Compile Unreal Plugin
echo ============================================================
echo.

set UNREAL_DIR=%~dp0
set OUT_DIR=%UNREAL_DIR%_out

if not exist "%OUT_DIR%" (
    echo  ERROR: _out folder not found!
    echo.
    echo  Run step1_cmake.bat first to generate the CMake solution.
    echo.
    pause
    exit /b 1
)

echo  Building from: %OUT_DIR%
echo.
echo  Config: Release
echo.

REM Build Release configuration
cmake --build "%OUT_DIR%" --config Release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  FAILED: Build failed.
    echo  Check the error messages above.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Success! Build complete.
echo.
echo  Output binaries should be available in the build directory.
echo ============================================================
echo.
pause