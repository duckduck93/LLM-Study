# 현재 OS가 macOS인지 확인
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "현재 OS는 macOS입니다."
    PY_VER=$(python3 --version 2>&1 | awk '{print $2}')
    PY_MAJOR=$(echo $PY_VER | cut -d. -f1)
    PY_MINOR=$(echo $PY_VER | cut -d. -f2)
    if [[ $PY_MAJOR -eq 3 && $PY_MINOR -ge 13 ]] || [[ $PY_MAJOR -gt 3 ]]; then
        echo "Python 버전이 3.13 이상입니다."
        python3 -m venv venv
        source venv/bin/activate
        # 가상환경 진입 여부 확인
        if [[ -z "$VIRTUAL_ENV" ]]; then
            echo "가상환경 활성화에 실패했습니다. 스크립트를 종료합니다."
            exit 1
        fi
        pip install -r requirements.txt
        # Jupyter Notebook 실행
        if command -v jupyter >/dev/null 2>&1; then
            echo "Jupyter Notebook을 실행합니다."
            jupyter notebook

            open -a "Google Chrome" "http://localhost:8888"
        else
            echo "Jupyter가 설치되어 있지 않습니다. pip로 설치 후 실행합니다."
            pip install notebook
            jupyter notebook

            open -a "Google Chrome" "http://localhost:8888"
        fi
    else
        echo "Python 3.13 이상이 필요합니다. 설치 가이드를 참고하세요."
        echo "--- Python 3.13 설치 가이드 ---"
        echo "1. Homebrew가 없다면 설치"
        echo "2. Python 설치: brew install python@3.13"
        echo "3. 터미널 재시작 후 python3 --version으로 확인"
    fi
else
    echo "이 스크립트는 macOS에서만 동작하도록 설계되었습니다."
fi
