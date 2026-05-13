@echo off
cd /d "%~dp0.."

echo %~dp0

set EXE=_out\src\itest\Release\phonon_itest.exe
set PHONON_AUDIO_TEST_DIR=%cd%\data\audio\

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
