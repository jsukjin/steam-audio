@echo off
chcp 65001 >nul
echo ============================================================
echo  [README] Wwise CMake Build Workflow
echo ============================================================
echo.
echo  This folder contains automated batch scripts for building
echo  the Steam Audio Wwise plugin using CMake.
echo.
echo  ============================================================
echo  BUILD WORKFLOW
echo  ============================================================
echo.
echo  STEP 0: Clean Build (Optional)
echo  -------
echo    step0_clean.bat
echo.
echo    Removes previous build artifacts:
echo      - _out\  (CMake output directory)
echo.
echo    Use this if you want a fresh build from scratch.
echo.
echo  STEP 1: CMake Configure
echo  -------
echo    step1_cmake.bat
echo.
echo    Runs CMake to:
echo      - Scan project configuration
echo      - Execute Premake to generate Visual Studio projects
echo      - Output: _out\ directory with CMake files
echo.
echo    REQUIREMENTS:
echo      - CMake 3.17+ installed
echo      - Visual Studio 17 2022 (or later) installed
echo      - Python 3 installed (for Wwise build system)
echo      - Wwise SDK available in system environment
echo      - Steam Audio Core library available
echo.
echo  STEP 2: Open in Visual Studio
echo  -------
echo    step2_build.bat
echo.
echo    Opens the generated Visual Studio solution:
echo      - File: src\SteamAudioWwise_Windows_vc170_shared.sln
echo.
echo    From here you can:
echo      - View and edit source code
echo      - Build the project directly in Visual Studio
echo      - Debug the code
echo.
echo  ============================================================
echo  EXPECTED DIRECTORY STRUCTURE
echo  ============================================================
echo.
echo    F:\GitHub\steam-audio\wwise\
echo    ├── step0_clean.bat          (Remove build artifacts)
echo    ├── step1_cmake.bat          (Run CMake configure)
echo    ├── step2_build.bat          (Open in Visual Studio)
echo    ├── CMakeLists.txt           (Main CMake configuration)
echo    ├── src\                     (Source code)
echo    │   ├── CMakeLists.txt
echo    │   ├── SoundEnginePlugin\   (Main plugin source files)
echo    │   └── WwisePlugin\         (Authoring/GUI files)
echo    ├── build\                   (Build scripts and helpers)
echo    └── _out\                    (CMake output - auto generated)
echo        ├── CMakeFiles\
echo        ├── src\                 (Generated project files)
echo        └── SteamAudioWwise.sln
echo.
echo  ============================================================
echo  DEPENDENCIES & ENVIRONMENT
echo  ============================================================
echo.
echo  Required:
echo    - CMake 3.17 or newer
echo    - Visual Studio 17 2022 (for vc170 toolchain)
echo    - Python 3.6+
echo.
echo  Environment Variables (for advanced builds):
echo    - WWISE_ROOT           (Wwise SDK installation path)
echo    - STEEMAUDIO_ROOT      (Steam Audio Core library path)
echo    - CMAKE_PREFIX_PATH    (For custom dependency locations)
echo.
echo  ============================================================
echo.
pause