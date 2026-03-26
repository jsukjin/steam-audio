@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 5] CMake Configure - Generate Phonon.sln
echo ============================================================
echo.
echo  CMake will scan all dependencies via FindXXX.cmake
echo  and generate the Visual Studio solution file.
echo.

set CORE_DIR=%~dp0
set CORE_DIR=%CORE_DIR:~0,-1%
set OUT_DIR=%CORE_DIR%\_out

echo  Output : %OUT_DIR%\Phonon.sln
echo.

echo [Removing existing _out folder to avoid CMakeCache conflicts]
if exist "%OUT_DIR%" (
    echo   Deleting _out ...
    rmdir /s /q "%OUT_DIR%"
    echo   Done
) else ( echo   No _out folder, skipping )

echo.
echo [Running CMake configure]
cmake -S "%CORE_DIR%" -B "%OUT_DIR%" -G "Visual Studio 17 2022" -A x64


if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  FAILED: CMake configure failed.
    echo  Check the error messages above.
    echo  If a REQUIRED dependency is missing, run step4_fix_stamps.bat first.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Success!
echo.
echo  Solution file : %OUT_DIR%\Phonon.sln
echo.
echo  Open in Visual Studio, or build from command line:
echo    cmake --build "%OUT_DIR%" --config Release
echo ============================================================
echo.
pause