@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 4] CMake configure - Phonon.sln 생성
echo ============================================================
echo.
echo  CMake가 FindXXX.cmake 파일을 통해 모든 의존성을 탐색하고
echo  Visual Studio 솔루션 파일을 생성합니다.
echo.

set CORE_DIR=%~dp0core
set OUT_DIR=%CORE_DIR%\out

echo  생성 위치: %OUT_DIR%\Phonon.sln
echo.

echo [기존 _out 폴더 삭제 (CMakeCache 충돌 방지)]
if exist "%OUT_DIR%" (
    echo   삭제 중: %OUT_DIR%
    rmdir /s /q "%OUT_DIR%"
    echo   완료
) else ( echo   _out 폴더 없음, 건너뜀 )

echo.
echo [CMake configure 실행]
cmake -S "%CORE_DIR%" -B "%OUT_DIR%" -G "Visual Studio 17 2022" -A x64

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo FAILED: cmake configure 실패.
    echo 위 오류 메시지를 확인하세요.
    echo REQUIRED 의존성이 누락된 경우 step3_fix_stamp.bat 을 먼저 실행하세요.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  완료!
echo.
echo  솔루션 파일 위치:
echo    %OUT_DIR%\Phonon.sln
echo.
echo  Visual Studio에서 열거나 커맨드라인 빌드:
echo    cmake --build "%OUT_DIR%" --config Release
echo ============================================================
echo.
pause