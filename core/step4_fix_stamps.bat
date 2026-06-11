@echo off
chcp 65001 >nul

echo ============================================================
echo  [STEP 4] Fix flatbuffers / pffft stamp cache and rebuild
echo ============================================================
echo.

set "CORE_DIR=%~dp0"
set "DEPS_BUILD=%CORE_DIR%deps-build"
set "BUILD_DIR=%CORE_DIR%build"

REM ============================================================
REM Detect installed Visual Studio
REM ============================================================

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" goto :FOUND_VSWHERE

set "VSWHERE=%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" goto :FOUND_VSWHERE

echo [ERROR] Visual Studio Installer not found.
goto :ERROR_PAUSE


:FOUND_VSWHERE
:: 안전하게 임시 파일을 이용해 버전 및 라인 버전 추출
"%VSWHERE%" -latest -products * -property installationVersion > "%temp%\vs_ver.txt" 2>nul
set /p VS_VERSION=<"%temp%\vs_ver.txt"
del "%temp%\vs_ver.txt"

"%VSWHERE%" -latest -products * -property catalog_productLineVersion > "%temp%\vs_major.txt" 2>nul
set /p VS_MAJOR=<"%temp%\vs_major.txt"
del "%temp%\vs_major.txt"

echo Found VS Version: %VS_VERSION%
echo Detected Visual Studio : %VS_MAJOR%

:: 메이저 버전 번호 기반 Generator 매핑
set "VS_MAJOR_NUM=%VS_VERSION:~0,2%"
set "VS_GENERATOR="

if "%VS_MAJOR_NUM%"=="18" set "VS_GENERATOR=Visual Studio 18 2026"
if "%VS_MAJOR_NUM%"=="17" set "VS_GENERATOR=Visual Studio 17 2022"
if "%VS_MAJOR_NUM%"=="16" set "VS_GENERATOR=Visual Studio 16 2019"

if "%VS_GENERATOR%"=="" (
    echo [ERROR] Unsupported Visual Studio version.
    goto :ERROR_PAUSE
)

echo Using Generator: %VS_GENERATOR%


REM ============================================================
REM 툴체인 분기 처리 (get_dependencies.py 예외 허용을 위해 vs2022 고정)
REM ============================================================
set "TOOLCHAIN=vs2022"

if "%VS_MAJOR%"=="2026" goto :SETUP_VS2026
if "%VS_MAJOR%"=="18" goto :SETUP_VS2026
goto :PATCH_SCRIPTS


:SETUP_VS2026
:: 스크립트 내부 Generator 문자열 패치만 진행
goto :PATCH_SCRIPTS


:PATCH_SCRIPTS
REM ============================================================
REM 임시 파이썬 스크립트를 생성하여 파일 치환 수행
REM ============================================================
echo [INFO] Patching Python scripts via temporary patcher...

echo import os > "%temp%\audio_patch.py"
echo def patch(file_path, new_str): >> "%temp%\audio_patch.py"
echo     if not os.path.exists(file_path): return >> "%temp%\audio_patch.py"
echo     content = '' >> "%temp%\audio_patch.py"
echo     for enc in ['utf-8', 'cp949', 'latin-1']: >> "%temp%\audio_patch.py"
echo         try: >> "%temp%\audio_patch.py"
echo             with open(file_path, 'r', encoding=enc) as f: content = f.read() >> "%temp%\audio_patch.py"
echo             break >> "%temp%\audio_patch.py"
echo         except: continue >> "%temp%\audio_patch.py"
echo     if not content: return >> "%temp%\audio_patch.py"
echo     patched = content.replace('Visual Studio 17 2022', new_str).replace('Visual Studio 16 2019', new_str) >> "%temp%\audio_patch.py"
echo     with open(file_path, 'w', encoding='utf-8') as f: f.write(patched) >> "%temp%\audio_patch.py"

set "TARGET_DEPS=%CORE_DIR%build\get_dependencies.py"
set "TARGET_BUILD=%CORE_DIR%build\build.py"

echo patch(r'%TARGET_DEPS%', r'%VS_GENERATOR%') >> "%temp%\audio_patch.py"
echo patch(r'%TARGET_BUILD%', r'%VS_GENERATOR%') >> "%temp%\audio_patch.py"

python "%temp%\audio_patch.py"
set "PATCH_STATUS=%ERRORLEVEL%"
del "%temp%\audio_patch.py"

if %PATCH_STATUS% NEQ 0 (
    echo [ERROR] Python script modification failed.
    goto :ERROR_PAUSE
)

echo [OK] Python scripts patched successfully.


:CACHE_CLEAN
echo Using Toolchain Target: %TOOLCHAIN% (Patched internally for VS2026)
echo.

REM ============================================================
REM Delete flatbuffers cache
REM ============================================================
echo [flatbuffers - delete cache]
if exist "%DEPS_BUILD%\flatbuffers\src"   rmdir /s /q "%DEPS_BUILD%\flatbuffers\src"
if exist "%DEPS_BUILD%\flatbuffers\build" rmdir /s /q "%DEPS_BUILD%\flatbuffers\build"
if exist "%DEPS_BUILD%\flatbuffers\stamp" rmdir /s /q "%DEPS_BUILD%\flatbuffers\stamp"

echo.
REM ============================================================
REM Delete pffft cache
REM ============================================================
echo [pffft - delete cache]
if exist "%DEPS_BUILD%\pffft\src"   rmdir /s /q "%DEPS_BUILD%\pffft\src"
if exist "%DEPS_BUILD%\pffft\build" rmdir /s /q "%DEPS_BUILD%\pffft\build"
if exist "%DEPS_BUILD%\pffft\stamp" rmdir /s /q "%DEPS_BUILD%\pffft\stamp"

echo.
REM ============================================================
REM Rebuild flatbuffers
REM ============================================================
cd /d "%BUILD_DIR%"
if %ERRORLEVEL% NEQ 0 echo [ERROR] Failed to change directory to %BUILD_DIR% & goto :ERROR_PAUSE

echo [flatbuffers - rebuild]
python get_dependencies.py -p windows -a x64 -t %TOOLCHAIN% --dependency flatbuffers
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] flatbuffers Python build failed.
    goto :ERROR_PAUSE
)

echo.
REM ============================================================
REM Rebuild pffft
REM ============================================================
echo [pffft - rebuild]
python get_dependencies.py -p windows -a x64 -t %TOOLCHAIN% --dependency pffft
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] pffft Python build failed.
    goto :ERROR_PAUSE
)

echo.
echo ============================================================
echo Done. Next: step5_cmake.bat
echo ============================================================
pause
exit /b 0


:ERROR_PAUSE
echo.
echo -----------------------------------------------------------
echo [STOP] 에러를 포착하여 스크립트를 일시 정지했습니다.
echo -----------------------------------------------------------
pause
exit /b 1