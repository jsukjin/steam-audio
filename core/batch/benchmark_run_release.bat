@echo off
cd /d "%~dp0.."
echo %~dp0

:: 1. base dir (batch file location)
set "BASE_DIR=%~dp0"

:: 2. resolve root dir (core folder, two levels up from batch dir + 1)
pushd "%BASE_DIR%.."
set "ROOT_DIR=%CD%"
popd
set "EXE=%ROOT_DIR%\_out\src\benchmark\Release\phonon_perf.exe"

:: Several benchmarks (scene, raytracer, ...) load .obj meshes using a path
:: hardcoded relative to CWD: "../../data/meshes/sponza.obj". That only resolves
:: correctly to core\data\meshes\sponza.obj when CWD is core\src\benchmark.
set "RUN_DIR=%ROOT_DIR%\src\benchmark"

echo exe dir =
echo %EXE%
echo run dir (CWD) =
echo %RUN_DIR%

if not exist "%EXE%" (
    echo ERROR: %EXE% not found.
    echo Run benchmark_build_release.bat first.
    pause
    exit /b 1
)

echo Available benchmark list:
echo.
pushd "%RUN_DIR%"
"%EXE%"
popd
echo.

set /p NAME="Enter benchmark name (or 'all'): "

if "%NAME%"=="" (
    echo No name entered.
    pause
    exit /b 1
)

set /p LOGFILE="Optional output log file (press Enter to skip): "

echo.
echo Running [%NAME%]...
echo (running from %RUN_DIR% so relative resource paths like ../../data/meshes/sponza.obj resolve)
echo.

pushd "%RUN_DIR%"
if "%LOGFILE%"=="" (
    "%EXE%" %NAME%
) else (
    "%EXE%" %NAME% "%LOGFILE%"
)
popd

echo.
pause
