@echo off
cd /d "%~dp0.."
echo %~dp0

:: 1. 기준 경로 설정 (배치파일 위치)
set "BASE_DIR=%~dp0"

:: 2. 상위 2단계 경로 계산 (정규화)
pushd "%BASE_DIR%.."
set "ROOT_DIR=%CD%"
popd
set EXE=_out\src\itest\Release\phonon_itest.exe
set PHONON_AUDIO_TEST_DIR=%ROOT_DIR%\data\audio\
set PHONON_MESHES_TEST_DIR=%ROOT_DIR%\data\meshes\

echo exe dir =
echo %EXE%
echo audio dir =
echo %PHONON_AUDIO_TEST_DIR%

if not exist "%EXE%" (
    echo ERROR: %EXE% not found.
    echo Run Build_Phonon_itest_Release.bat first.
    pause
    exit /b 1
)

echo Available itest list:
echo.
"%EXE%"
echo.

set /p NAME="Enter itest name: "

if "%NAME%"=="" (
    echo No name entered.
    pause
    exit /b 1
)

echo.
echo Running [%NAME%]...
echo.

"%EXE%" %NAME%

echo.
pause
