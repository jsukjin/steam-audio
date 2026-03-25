@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 2] 전체 의존성 다운로드 + 빌드
echo ============================================================
echo.
echo  이 단계에서 다운로드/빌드되는 라이브러리:
echo.
echo  [필수]
echo    - FlatBuffers  : 직렬화 도구 (flatc.exe 포함)
echo    - PFFFT        : FFT 연산 라이브러리
echo    - MySOFA       : HRTF 데이터 처리
echo    - zlib         : 압축 라이브러리 (MySOFA 의존)
echo.
echo  [선택 - 없어도 빌드 가능]
echo    - Embree + ISPC : 레이트레이싱 가속 (시간 많이 걸림)
echo    - Catch2        : 유닛 테스트
echo    - GLFW/ImGui    : 인터랙티브 테스트 UI
echo    - PortAudio     : 오디오 I/O
echo    - IPP           : Intel 고성능 연산 (수동 설치 필요)
echo.
echo  예상 시간: 10~20분 (인터넷 속도에 따라 다름)
echo.
echo 계속하려면 아무 키나 누르세요...
pause >nul

set CORE_DIR=%~dp0core
cd /d "%CORE_DIR%\build"

python get_dependencies.py -p windows -a x64 -t vs2022

echo.
echo ============================================================
echo  의존성 스크립트 완료.
echo  SUMMARY에서 REQUIRED 항목이 failed면 step3을 실행하세요.
echo  OPTIONAL 항목 실패는 무시해도 됩니다.
echo ============================================================
echo.
pause