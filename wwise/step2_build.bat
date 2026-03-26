@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 2] Open Wwise Project - Visual Studio
echo ============================================================
echo.

set WWISE_DIR=%~dp0
set SRC_DIR=%WWISE_DIR%src

echo  Checking for available solution files...
echo.

if exist "%SRC_DIR%\SteamAudioWwise_Windows_vc170_shared.sln" (
    echo  Found: SteamAudioWwise_Windows_vc170_shared.sln
    echo  Opening in Visual Studio...
    echo.
    start "" "%SRC_DIR%\SteamAudioWwise_Windows_vc170_shared.sln"
) else if exist "%SRC_DIR%\SteamAudioWwise_Windows_vc160_shared.sln" (
    echo  Found: SteamAudioWwise_Windows_vc160_shared.sln
    echo  Opening in Visual Studio...
    echo.
    start "" "%SRC_DIR%\SteamAudioWwise_Windows_vc160_shared.sln"
) else (
    echo  ERROR: No Visual Studio solution files found!
    echo.
    echo  Make sure step1_cmake.bat has completed successfully.
    echo  Solution files should be generated in:
    echo    %SRC_DIR%\
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Solution opened in Visual Studio.
echo.
echo  Note: Solution files are pre-generated using PremakePlugin.
echo  Source code is visible through Visual Studio's project.
echo ============================================================
echo.
pause