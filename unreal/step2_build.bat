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

REM ------------------------------------------------------------
REM  Visual Studio generator selection
REM    step1_cmake.bat          : auto-detect latest installed VS
REM    step1_cmake.bat 2022     : force Visual Studio 17 2022
REM    step1_cmake.bat 2026     : force Visual Studio 18 2026
REM  Note: VS 2026 generator requires CMake 4.2 or later.
REM ------------------------------------------------------------
set "GEN="
set "VS_MAJOR="
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

if /i "%~1"=="2026" set "GEN=Visual Studio 18 2026"
if /i "%~1"=="2022" set "GEN=Visual Studio 17 2022"

if defined GEN goto :gen_done
if not exist "%VSWHERE%" goto :gen_fallback

for /f "usebackq tokens=1 delims=." %%v in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationVersion`) do set "VS_MAJOR=%%v"

if "%VS_MAJOR%"=="18" set "GEN=Visual Studio 18 2026"
if "%VS_MAJOR%"=="17" set "GEN=Visual Studio 17 2022"

:gen_fallback
if not defined GEN set "GEN=Visual Studio 17 2022"

:gen_done

echo  Source    : %UNREAL_DIR:~0,-1%
echo  Output    : %OUT_DIR%\Phonon.sln
echo  Generator : %GEN%
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
set OUT=%OUT_DIR%

REM CMake configuration for Unreal Engine plugin
REM Additional options can be added here:
REM   -DSTEAMAUDIOUNREAL_TARGET_UE4=ON          - Build for UE4 instead of UE5
REM   -DSTEAMAUDIOUNREAL_BUILD_DOCS=ON          - Build documentation
REM   -DUnreal_EXECUTABLE_DIR="path/to/ue"     - Specify Unreal Engine binary path

cmake -S "%SRC%" -B "%OUT%" -G "%GEN%" -A x64

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  FAILED: CMake configure failed.
    echo  Check the error messages above.
    echo  Verify that CMake, Visual Studio 2022 or 2026, and Unreal Engine SDK are installed.
    echo  Note: "Visual Studio 18 2026" requires CMake 4.2 or later.
    echo  To force a version, run: step1_cmake.bat 2022  or  step1_cmake.bat 2026
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Success!
echo.
echo  Generator     : %GEN%
echo  Solution file : %OUT_DIR%\Phonon.sln
echo.
echo  Next steps:
echo    1. Open in Visual Studio: %OUT_DIR%\Phonon.sln
echo    2. Or build from command line:
echo       cmake --build "%OUT_DIR%" --config Release
echo ============================================================
echo.
pause