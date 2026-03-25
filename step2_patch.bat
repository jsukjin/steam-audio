@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 1] get_dependencies.py CMake 4.x 호환 패치
echo ============================================================
echo.
echo  목적: CMake 4.x에서 구버전 CMakeLists.txt 호환성 오류 방지
echo  수정: cmake_args = [] 를
echo        cmake_args = ['-DCMAKE_POLICY_VERSION_MINIMUM=3.5'] 로 변경
echo.

set CORE_DIR=%~dp0core
set TARGET=%CORE_DIR%\build\get_dependencies.py
set HELPER=%~dp0_patch_helper.py

echo  대상 파일: %TARGET%
echo.

:: Python 헬퍼 스크립트를 임시로 생성
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
echo     print('[OK] 패치 완료') >> "%HELPER%"
echo elif new in content: >> "%HELPER%"
echo     print('[OK] 이미 패치되어 있음. 건너뜀.') >> "%HELPER%"
echo else: >> "%HELPER%"
echo     print('[ERROR] 패치 대상을 찾을 수 없습니다.') >> "%HELPER%"
echo     sys.exit(1) >> "%HELPER%"

echo  패치 실행 중...
python "%HELPER%" "%TARGET%"
set RESULT=%ERRORLEVEL%

:: 헬퍼 파일 삭제
del "%HELPER%" >nul 2>&1

echo.
if %RESULT% NEQ 0 (
    echo  FAILED: 패치 실패.
    echo  get_dependencies.py 파일을 직접 열어서
    echo  configure_cmake 함수 안의 cmake_args = [] 를
    echo  cmake_args = ['-DCMAKE_POLICY_VERSION_MINIMUM=3.5'] 로
    echo  수동으로 변경하세요.
    echo.
    pause
    exit /b 1
)

echo  패치 성공!
echo.
echo  다음 단계: step2_get_deps.bat 실행
echo.
pause
exit /b 0