@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 1] CMake Configure - Generate Visual Studio Solution
echo ============================================================
echo.
echo  CMake will scan the project configuration
echo  and generate the Visual Studio solution file.
echo.
echo  Target: Unreal Engine Audio Plugin (Phonon)
echo  Version: 4.8.1
echo.

set UNREAL_DIR=%~dp0
set OUT_DIR=%UNREAL_DIR%_out

echo  Source  : %UNREAL_DIR:~0,-1%
echo  Output  : %OUT_DIR%\Phonon.sln
echo.

echo [Removing existing _out folder to avoid CMakeCache conflicts]
if exist "%OUT_DIR%" (
    echo   Deleting _out ...
    rmdir /s /q "%OUT_DIR%"
    echo   Done
) else ( echo   No _out folder, skipping )

echo.
echo [Running CMake configure]
set SRC=%UNREAL_DIR:~0,-1%
set OUT=%OUT_DIR:~0,-1%

REM CMake configuration for Unreal Engine plugin
REM Additional options can be added here:
REM   -DSTEAMAUDIOUNREAL_TARGET_UE4=ON          - Build for UE4 instead of UE5
REM   -DSTEAMAUDIOUNREAL_BUILD_DOCS=ON          - Build documentation
REM   -DUnreal_EXECUTABLE_DIR="path/to/ue"     - Specify Unreal Engine binary path

cmake -S "%SRC%" -B "%OUT%" -G "Visual Studio 17 2022" -A x64

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  FAILED: CMake configure failed.
    echo  Check the error messages above.
    echo  Verify that CMake, Visual Studio 17 2022 (or later), and Unreal Engine SDK are installed.
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
echo  Next steps:
echo    1. Open in Visual Studio: %OUT_DIR%\Phonon.sln
echo    2. Or build from command line:
echo       cmake --build "%OUT_DIR%" --config Release
echo ============================================================
echo.
pause