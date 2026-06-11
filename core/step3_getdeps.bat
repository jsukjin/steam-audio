@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 3] Download and Build All Dependencies
echo ============================================================
echo.
echo  Libraries to be downloaded and built:
echo.
echo  [Required]
echo    - FlatBuffers  : Serialization tool (includes flatc.exe)
echo    - PFFFT        : FFT library
echo    - MySOFA       : HRTF data processing
echo    - zlib         : Compression (required by MySOFA)
echo.
echo  [Optional - build still works without these]
echo    - Embree + ISPC : Ray tracing acceleration (takes long)
echo    - Catch2        : Unit tests
echo    - GLFW/ImGui    : Interactive test UI
echo    - PortAudio     : Audio I/O
echo    - IPP           : Intel high-performance math (manual install)
echo.
echo  Estimated time: 10-20 min depending on internet speed.
echo.
echo  Press any key to continue...
pause >nul

set CORE_DIR=%~dp0
cd /d "%CORE_DIR%build"


@echo off

set VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

for /f "usebackq delims=" %%i in (`
    %VSWHERE% -latest -products * -property installationVersion
`) do set VS_VERSION=%%i

set TOOLCHAIN=

echo %VS_VERSION% | findstr /b "18." >nul
if not errorlevel 1 set TOOLCHAIN=vs2026

echo %VS_VERSION% | findstr /b "17." >nul
if not errorlevel 1 set TOOLCHAIN=vs2022

echo %VS_VERSION% | findstr /b "16." >nul
if not errorlevel 1 set TOOLCHAIN=vs2019

if "%TOOLCHAIN%"=="" (
    echo Unsupported Visual Studio version: %VS_VERSION%
    pause
    exit /b 1
)

echo Detected Visual Studio: %VS_VERSION%
echo Using toolchain: %TOOLCHAIN%

python get_dependencies.py -p windows -a x64 -t %TOOLCHAIN%

##python get_dependencies.py -p windows -a x64 -t vs2022

echo.
echo ============================================================
echo  Done.
echo  Check SUMMARY above:
echo    - REQUIRED failed -> run step4_fix_stamps.bat
echo    - OPTIONAL failed -> safe to ignore
echo  If all REQUIRED passed -> skip to step5_cmake.bat
echo ============================================================
echo.
pause