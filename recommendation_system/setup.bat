@echo off
echo.
echo ================================================
echo  ClubHub Recommendation System - Quick Start
echo ================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.8+ from python.org
    pause
    exit /b 1
)

echo [1/5] Checking Python installation...
python --version
echo.

REM Check if serviceAccountKey.json exists
if not exist "serviceAccountKey.json" (
    echo [ERROR] serviceAccountKey.json not found!
    echo.
    echo Please:
    echo 1. Go to Firebase Console
    echo 2. Project Settings ^> Service Accounts
    echo 3. Generate New Private Key
    echo 4. Save as serviceAccountKey.json in this directory
    echo.
    pause
    exit /b 1
)

echo [2/5] Found serviceAccountKey.json
echo.

REM Check if virtual environment exists
if not exist "venv" (
    echo [3/5] Creating virtual environment...
    python -m venv venv
    echo.
) else (
    echo [3/5] Virtual environment already exists
    echo.
)

REM Activate virtual environment
echo [4/5] Activating virtual environment...
call venv\Scripts\activate.bat
echo.

REM Install requirements
echo [5/5] Installing dependencies...
pip install -r requirements.txt --quiet
echo.

echo ================================================
echo  Setup Complete!
echo ================================================
echo.
echo You can now:
echo   1. Test Firebase: python test_firebase.py
echo   2. Populate DB:   python populate_database.py
echo   3. Start API:     python api.py
echo.
echo To activate environment manually: venv\Scripts\activate.bat
echo.

pause
