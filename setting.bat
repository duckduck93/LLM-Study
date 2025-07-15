@echo off
REM 현재 OS가 Windows인지 확인
ver | findstr /I "windows" >nul
if %errorlevel% neq 0 (
    echo 이 스크립트는 Windows에서만 동작하도록 설계되었습니다.
    exit /b 1
)

REM Python 버전 확인
for /f "tokens=2 delims== " %%I in ('python --version 2^>^&1') do set PY_VER=%%I
for /f "tokens=1,2 delims=." %%A in ("%PY_VER%") do (
    set PY_MAJOR=%%A
    set PY_MINOR=%%B
)

REM Python 3.13 이상인지 확인
set CHECK_VER=0
if %PY_MAJOR% GEQ 3 (
    if %PY_MINOR% GEQ 13 (
        set CHECK_VER=1
    )
    if %PY_MAJOR% GTR 3 (
        set CHECK_VER=1
    )
)

if %CHECK_VER%==1 (
    echo Python 버전이 3.13 이상입니다.
    python -m venv venv
    call venv\Scripts\activate.bat
    if "%VIRTUAL_ENV%"=="" (
        echo 가상환경 활성화에 실패했습니다. 스크립트를 종료합니다.
        exit /b 1
    )
    pip install -r requirements.txt
    where jupyter >nul 2>nul
    if %errorlevel%==0 (
        echo Jupyter Notebook을 실행합니다.
        jupyter notebook
    ) else (
        echo Jupyter가 설치되어 있지 않습니다. pip로 설치 후 실행합니다.
        pip install notebook
        jupyter notebook
    )
) else (
    echo Python 3.13 이상이 필요합니다. 설치 가이드를 참고하세요.
    echo --- Python 3.13 설치 가이드 ---
    echo 1. https://www.python.org/downloads/windows/ 에서 Python 3.13 이상 다운로드 및 설치
    echo 2. 설치 후 명령 프롬프트를 재시작하고 python --version으로 확인
)

