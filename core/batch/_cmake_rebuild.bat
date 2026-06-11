@echo off
chcp 65001 >nul

echo ============================================================
echo  CMake Configure - Generate Solution (Auto VS Version)
echo ============================================================
echo.

:: 스크립트 위치 기준으로 한 단계 상위 폴더로 이동
cd /d "%~dp0.."

set "OUT_DIR=_out"

:: CMakeCache 충돌 방지를 위해 기존 _out 폴더 초기화
if exist "%OUT_DIR%" (
    echo [INFO] Removing existing %OUT_DIR% folder...
    rmdir /s /q "%OUT_DIR%"
)

echo [INFO] Detecting latest Visual Studio...
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" goto :FOUND_VSWHERE

set "VSWHERE=%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" goto :FOUND_VSWHERE

echo [ERROR] Visual Studio Installer not found.
goto :ERROR_PAUSE


:FOUND_VSWHERE
:: 안전하게 버전 및 라인 버전 추출
"%VSWHERE%" -latest -products * -property installationVersion > "%temp%\vs_root_ver.txt"
set /p VS_VERSION=<"%temp%\vs_root_ver.txt"
del "%temp%\vs_root_ver.txt"

set "VS_MAJOR_NUM=%VS_VERSION:~0,2%"
set "GENERATOR="

if "%VS_MAJOR_NUM%"=="18" set "GENERATOR=Visual Studio 18 2026"
if "%VS_MAJOR_NUM%"=="17" set "GENERATOR=Visual Studio 17 2022"
if "%VS_MOTOR_NUM%"=="16" set "GENERATOR=Visual Studio 16 2019"

if "%GENERATOR%"=="" (
    echo [ERROR] Unsupported Visual Studio version.
    goto :ERROR_PAUSE
)

echo [OK] Using Generator: %GENERATOR%
echo.

:: CMake 실행 (call 제거, 에러 레벨 체크)
cmake -B "%OUT_DIR%" -G "%GENERATOR%" -A x64

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] CMake configure failed.
    goto :ERROR_PAUSE
)

echo.
echo ============================================================
echo Success!
echo ============================================================
pause
exit /b 0


:ERROR_PAUSE
echo.
echo -----------------------------------------------------------
echo FAILED: CMake configure failed.
echo -----------------------------------------------------------
pause
exit /b 1