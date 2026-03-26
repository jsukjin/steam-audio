@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 0] Steam Audio Unreal - Clean Build
echo ============================================================
echo.
echo  The following folders will be deleted:
echo.
echo    build\      - CMake build files
echo    _out\       - CMake output (*.sln, *.vcxproj, etc.)
echo.
echo  After clean, run step1 through step2 again from scratch.
echo.
echo  Press any key to continue, or close this window to cancel.
pause >nul

set UNREAL_DIR=%~dp0

echo.
echo [1/2] Deleting build ...
if exist "%UNREAL_DIR%build" (
    rmdir /s /q "%UNREAL_DIR%build"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo [2/2] Deleting _out ...
if exist "%UNREAL_DIR%_out" (
    rmdir /s /q "%UNREAL_DIR%_out"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo ============================================================
echo  Clean complete.
echo.
echo  Run order:
echo    1. step1_cmake.bat
echo    2. step2_build.bat  (optional - build directly in Visual Studio)
echo ============================================================
echo.
pause