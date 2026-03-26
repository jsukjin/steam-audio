@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 2] Patch get_dependencies.py for CMake 4.x
echo ============================================================
echo.
echo  Purpose : Prevent CMakeLists.txt compatibility error on CMake 4.x
echo  Change  : cmake_args = []
echo         -> cmake_args = ['-DCMAKE_POLICY_VERSION_MINIMUM=3.5']
echo.

set CORE_DIR=%~dp0
set TARGET=%CORE_DIR%build\get_dependencies.py
set HELPER=%CORE_DIR%_patch_helper.py

echo  Target : %TARGET%
echo.

echo import sys > "%HELPER%"
echo path = sys.argv[1] >> "%HELPER%"
echo with open(path, 'r') as f: >> "%HELPER%"
echo     content = f.read() >> "%HELPER%"
echo old = '    cmake_args = []' >> "%HELPER%"
echo new = "    cmake_args = ['-DCMAKE_POLICY_VERSION_MINIMUM=3.5']" >> "%HELPER%"
echo if old in content: >> "%HELPER%"
echo     content = content.replace(old, new, 1) >> "%HELPER%"
echo     with open(path, 'w') as f: >> "%HELPER%"
echo         f.write(content) >> "%HELPER%"
echo     print('[OK] Patch applied.') >> "%HELPER%"
echo elif new in content: >> "%HELPER%"
echo     print('[OK] Already patched. Skipping.') >> "%HELPER%"
echo else: >> "%HELPER%"
echo     print('[ERROR] Patch target not found.') >> "%HELPER%"
echo     sys.exit(1) >> "%HELPER%"

echo  Running patch...
python "%HELPER%" "%TARGET%"
set RESULT=%ERRORLEVEL%

del "%HELPER%" >nul 2>&1

echo.
if %RESULT% NEQ 0 (
    echo  FAILED: Patch failed.
    echo  Manually edit build\get_dependencies.py:
    echo    Find   : cmake_args = []
    echo    Replace: cmake_args = ['-DCMAKE_POLICY_VERSION_MINIMUM=3.5']
    echo.
    pause
    exit /b 1
)

echo  Patch done. Next: step3_getdeps.bat
echo.
pause
exit /b 0