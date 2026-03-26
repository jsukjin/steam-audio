@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 0] Steam Audio Core - Clean Install
echo ============================================================
echo.
echo  The following folders will be deleted:
echo.
echo    deps\        - Installed headers and libs
echo    deps-build\  - Dependency sources, build files, stamps
echo    _out\        - CMake output (Phonon.sln, etc.)
echo.
echo  After clean, run step1 through step5 again from scratch.
echo.
echo  Press any key to continue, or close this window to cancel.
pause >nul

set CORE_DIR=%~dp0

echo.
echo [1/3] Deleting deps ...
if exist "%CORE_DIR%deps" (
    rmdir /s /q "%CORE_DIR%deps"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo [2/3] Deleting deps-build ...
if exist "%CORE_DIR%deps-build" (
    rmdir /s /q "%CORE_DIR%deps-build"
    echo   Done
) else ( echo   Not found, skipping )

echo.
echo [3/3] Deleting _out ...
if exist "%CORE_DIR%_out" (
    rmdir /s /q "%CORE_DIR%_out"
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
echo    4. step4_fix_stamps.bat  (only if REQUIRED failed in step3)
echo    5. step5_cmake.bat
echo ============================================================
echo.
pause