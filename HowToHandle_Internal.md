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


## How to start debug(visual)
### 1. phonon_itest 빌드 
(예 : debug 기준 나의경로 - F:\GitHub\steam-audio\core\_out\src\itest\Debug)

### 2. 경로에 맞게 실행
오디오 테스트
- \core\data\audio 에서 실행
예:
 경로 - F:\GitHub\steam-audio\core\data\audio
 cmd - F:\GitHub\steam-audio\core\_out\src\itest\Release\phonon_itest.exe eqeffect

### 3. visual + audio 경우 (eg : convolution effect)

#### libries info

##### ISPC (Intel SPMD Program Compiler)
공식: https://ispc.github.io/
GitHub: https://github.com/ispc/ispc
Intel이 만든 SIMD 병렬 프로그래밍 컴파일러
CPU의 SIMD 레인(SSE/AVX)을 자동으로 활용하는 코드를 생성
.ispc 확장자 소스를 C/C++에서 호출 가능한 .obj로 컴파일
Embree가 내부적으로 레이트레이싱 커널을 ISPC로 작성해서 Embree 빌드에 필수

##### Embree (Intel Embree Ray Tracing Kernels)
공식: https://www.embree.org/
GitHub: https://github.com/RenderKit/embree
Intel이 만든 고성능 레이트레이싱 라이브러리
BVH(Bounding Volume Hierarchy) 기반 레이-삼각형 교차 테스트를 AVX2/AVX-512로 가속
Steam Audio에서 SceneType::Embree 선택 시 사용
Phonon 기본 레이트레이서 대비 수배~수십배 빠름
(convolutioneffect, raytracer, directsiulator 등에서 쓰임)


##### Steam Audio에서의 관계
SceneType::Default   → Phonon 자체 BVH (순수 C++, 느림)
SceneType::Embree    → Intel Embree (ISPC 커널, 빠름)
SceneType::RadeonRays → AMD RadeonRays (OpenCL GPU, 매우 빠름)

-------------------------------------------
1.\core\build 에서 ispc 설치
cmd - python get_dependencies.py -p windows -a x64 -t vs2022 --dependency ispc

2. ispc.exe 설치 및 복사
경로 - \core\build
cmd - python get_dependencies.py -p windows -a x64 -t vs2022 --dependency ispc

 - 2.1 압축풀기
 - \core\deps-build\ispc\src\ispc-v1.12.0-windows.zip
 
 - 2.2 ispc.exe 복사
 - ispc-v1.12.0-windows\bin\ispc.exe
 
 - 2.3 해당 경로에 붙여넣기
 - core\deps\ispc\bin\windows-x64\ispc.exe

3. embree python 설치
경로 - \core\build
cmd - python get_dependencies.py -p windows -a x64 -t vs2022 --dependency embree

4. Cmake 재생성
 - step5_cmake.bat 실행
 
 5. 재빌드 (RelWithDebInfo)
 
 6. 실행 
 
 - 6.1 cmd에서 실행
	경로 - core\_out\src (_out은 cmake에서 정한 경로)
	cmd - 설치경로\core\[빌드경로]\src\itest\[빌드타입]\phonon_itest.exe [effectName]
	(예 : F:\GitHub\steam-audio\core\_out\src\itest\RelWithDebInfo\phonon_itest.exe convolutioneffect)

 - 6.2 VS에서 실행
   1. 프로젝트에서 phonon_itest 마우스 오른쪽 버튼 -> 속성 실행
   2. 구성 변경 (왼쪽 위) (예 : Debug, Release, RelWithDebugInfo)
   3. 구성속성 -> 디버깅 -> 명령인수 입력 (원하는 effecttype) (예 : convolutioneffect)
   4. 작업 디렉토리 -> 실행위치 설정 (\core\[빌드경로]\src) (예 : F:\GitHub\steam-audio\core\_out\src)
   
   









