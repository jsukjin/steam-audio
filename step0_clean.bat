@echo off
chcp 65001 >nul
echo ============================================================
echo  [CLEAN] Steam Audio Core - Clean Install
echo ============================================================
echo.
echo  The following folders will be deleted:
echo.
echo    core\deps\        - Installed headers and libs
echo    core\deps-build\  - Dependency sources, build files, stamps
echo    core\_out\        - CMake output (Phonon.sln, etc.)
echo.
echo  After clean, run step1 through step4 again from scratch.
echo.
echo  Press any key to continue, or close this window to cancel.
pause >nul

set CORE_DIR=%~dp0core

echo.
echo [1/3] Deleting core\deps ...
if exist "%CORE_DIR%\deps" (
    rmdir /s /q "%CORE_DIR%\deps"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo [2/3] Deleting core\deps-build ...
if exist "%CORE_DIR%\deps-build" (
    rmdir /s /q "%CORE_DIR%\deps-build"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo [3/3] Deleting core\out ...
if exist "%CORE_DIR%\_out" (
    rmdir /s /q "%CORE_DIR%\_out"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo ============================================================
echo  Clean complete.
echo.
echo  Run order:
echo    1. step1_check.bat
echo    2. step2_patch.bat
echo    3. step3_getdeps.bat
echo    3. step4_fix_stamp.bat   (only if REQUIRED failed in step2)
echo    4. step5_cmake.bat
echo ============================================================
echo.
pause