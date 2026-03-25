@echo off
chcp 65001 >nul
echo ============================================================
echo  [STEP 3] flatbuffers / pffft stamp 캐시 삭제 후 재빌드
echo ============================================================
echo.
echo  왜 이 단계가 필요한가?
echo.
echo  get_dependencies.py는 각 의존성의 빌드 상태를 stamp 폴더에 기록합니다.
echo  Step 2에서 flatbuffers/pffft가 한 번이라도 실패하면
echo  stamp에 실패 기록이 남아 다음 실행 시 configure를 건너뜁니다.
echo  그 결과 CMake 4.x 패치가 적용되지 않은 채 또 실패합니다.
echo.
echo  해결책: build + stamp 폴더를 삭제하고 단독으로 재실행합니다.
echo.

set CORE_DIR=%~dp0core
set DEPS_BUILD=%CORE_DIR%\deps-build

echo [flatbuffers 캐시 삭제]
if exist "%DEPS_BUILD%\flatbuffers\build" (
    echo   삭제 중: flatbuffers\build
    rmdir /s /q "%DEPS_BUILD%\flatbuffers\build"
    echo   완료
) else ( echo   build 폴더 없음, 건너뜀 )

if exist "%DEPS_BUILD%\flatbuffers\stamp" (
    echo   삭제 중: flatbuffers\stamp
    rmdir /s /q "%DEPS_BUILD%\flatbuffers\stamp"
    echo   완료
) else ( echo   stamp 폴더 없음, 건너뜀 )

echo.
echo [pffft 캐시 삭제]
if exist "%DEPS_BUILD%\pffft\build" (
    echo   삭제 중: pffft\build
    rmdir /s /q "%DEPS_BUILD%\pffft\build"
    echo   완료
) else ( echo   build 폴더 없음, 건너뜀 )

if exist "%DEPS_BUILD%\pffft\stamp" (
    echo   삭제 중: pffft\stamp
    rmdir /s /q "%DEPS_BUILD%\pffft\stamp"
    echo   완료
) else ( echo   stamp 폴더 없음, 건너뜀 )

echo.
echo [flatbuffers 재빌드]
cd /d "%CORE_DIR%\build"
python get_dependencies.py -p windows -a x64 -t vs2022 --dependency flatbuffers
if %ERRORLEVEL% NEQ 0 (
    echo   FAILED: flatbuffers 빌드 실패
    pause
    exit /b 1
)

echo.
echo [pffft 재빌드]
python get_dependencies.py -p windows -a x64 -t vs2022 --dependency pffft
if %ERRORLEVEL% NEQ 0 (
    echo   FAILED: pffft 빌드 실패
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  완료. 다음 단계: step4_cmake.bat
echo ============================================================
pause