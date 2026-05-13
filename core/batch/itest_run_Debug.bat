@echo off
cd /d "%~dp0.."

set EXE=_out\src\itest\Debug\phonon_itest.exe
set PHONON_AUDIO_DIR=%cd%\data\audio

if not exist "%EXE%" (
    echo ERROR: %EXE% not found.
    echo Run Build_Phonon_itest_Debug.bat first.
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
