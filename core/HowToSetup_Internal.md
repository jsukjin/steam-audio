# How to Setup Internal

cmake
https://cmake.org/download/

python
https://www.python.org/downloads/

Git
https://git-scm.com/install/

VS2022
https://visualstudio.microsoft.com/ko/downloads/


# How to sync with original upstream

## 1. GitHub 웹사이트에서 업데이트하기 (가장 간단함)
가장 빠르고 쉬운 방법입니다.

- 본인의 GitHub Fork 저장소 페이지로 이동합니다.
- 상단에 "Sync fork" 버튼을 클릭합니다.
- "Update branch" 버튼을 누르면 원본의 변경 사항이 내 Fork 저장소로 즉시 반영됩니다.

만약 내 작업 내용과 원본의 내용이 충돌(Conflict)한다면, 웹에서 바로 처리하기 어려우므로 아래 2번 방법을 권장합니다.


## 2. CLI엣 업데이트


1. 원본 저장소 주소를 upstream이라는 별칭으로 등록
git remote add upstream https://github.com/ValveSoftware/steam-audio.git

2. 연결 확인 (origin과 upstream이 모두 보여야 합니다)
git remote -v

3. 원본 저장소의 최신 이력 가져오기
git fetch upstream

4. 내 로컬 브랜치로 원본 내용 병합
git checkout main
git merge upstream/main

5. (선택 사항) 내 GitHub 저장소(Remote)에도 반영
git push origin main

## 3. Debug (Visual) 실행방법
1. phnon_itest 빌드
2. 빌드 된 경로에서 실행 (예: 나의 경로는 F:\GitHub\steam-audio\core\_out\src\itest\Debug)
3. cmd애서 phonon_itest.exe [test항목] (예 : phonon_itest.exe gui)

