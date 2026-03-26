@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 4] Fix flatbuffers / pffft stamp cache and rebuild
echo ============================================================
echo.
echo  Why is this needed?
echo.
echo  get_dependencies.py records build state in a 'stamp' folder.
echo  If flatbuffers or pffft failed in Step 3, the stamp retains
echo  the failure record. On the next run, it skips configure and
echo  reuses the failed cache - causing the same error again.
echo.
echo  Fix: Delete build + stamp folders, then rebuild individually.
echo.

set CORE_DIR=%~dp0
set DEPS_BUILD=%CORE_DIR%deps-build

echo [flatbuffers - delete cache]
if exist "%DEPS_BUILD%\flatbuffers\src" (
    echo   Deleting deps-build\flatbuffers\src ...
    rmdir /s /q "%DEPS_BUILD%\flatbuffers\src"
    echo   Done
) else ( echo   No src folder, skipping )

if exist "%DEPS_BUILD%\flatbuffers\build" (
    echo   Deleting deps-build\flatbuffers\build ...
    rmdir /s /q "%DEPS_BUILD%\flatbuffers\build"
    echo   Done
) else ( echo   No build folder, skipping )

if exist "%DEPS_BUILD%\flatbuffers\stamp" (
    echo   Deleting deps-build\flatbuffers\stamp ...
    rmdir /s /q "%DEPS_BUILD%\flatbuffers\stamp"
    echo   Done
) else ( echo   No stamp folder, skipping )

echo.
echo [pffft - delete cache]
if exist "%DEPS_BUILD%\pffft\src" (
    echo   Deleting deps-build\pffft\src ...
    rmdir /s /q "%DEPS_BUILD%\pffft\src"
    echo   Done
) else ( echo   No src folder, skipping )

if exist "%DEPS_BUILD%\pffft\build" (
    echo   Deleting deps-build\pffft\build ...
    rmdir /s /q "%DEPS_BUILD%\pffft\build"
    echo   Done
) else ( echo   No build folder, skipping )

if exist "%DEPS_BUILD%\pffft\stamp" (
    echo   Deleting deps-build\pffft\stamp ...
    rmdir /s /q "%DEPS_BUILD%\pffft\stamp"
    echo   Done
) else ( echo   No stamp folder, skipping )

echo.
echo [flatbuffers - rebuild]
cd /d "%CORE_DIR%build"
python get_dependencies.py -p windows -a x64 -t vs2022 --dependency flatbuffers
if %ERRORLEVEL% NEQ 0 (
    echo   FAILED: flatbuffers build failed.
    pause
    exit /b 1
)

echo.
echo [pffft - rebuild]
python get_dependencies.py -p windows -a x64 -t vs2022 --dependency pffft
if %ERRORLEVEL% NEQ 0 (
    echo   FAILED: pffft build failed.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Done. Next: step5_cmake.bat
echo ============================================================
echo.
pause