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

python get_dependencies.py -p windows -a x64 -t vs2022

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