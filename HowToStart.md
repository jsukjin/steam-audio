## How To Start ##

step bat 을 실행한다

1. step0_clean.bat
-  기존 설치된 폴더를 지운다 (재설치시)

2. step1_check.bat
- patch에 필요한 프로그램이 있는지 확인

3. step2_patch.bat
- 현재 기준 python 3.13에서 실행이 안되므로 패치 수정

4. step3_getdps.bat
- 필수 library 다운

5. step4_fix_stamps.bat
- 문제있는 라이브러리 (flatbuffers ,pffft) 재설치 (캐시 지우고 재설치)

6. step5_cmake.bat
- cmake 파일 생성( VS 2022)


