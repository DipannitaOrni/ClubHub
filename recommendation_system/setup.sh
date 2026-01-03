#!/bin/bash

echo ""
echo "================================================"
echo " ClubHub Recommendation System - Quick Start"
echo "================================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is not installed"
    echo "Please install Python 3.8+ from python.org"
    exit 1
fi

echo "[1/5] Checking Python installation..."
python3 --version
echo ""

# Check if serviceAccountKey.json exists
if [ ! -f "serviceAccountKey.json" ]; then
    echo "[ERROR] serviceAccountKey.json not found!"
    echo ""
    echo "Please:"
    echo "1. Go to Firebase Console"
    echo "2. Project Settings > Service Accounts"
    echo "3. Generate New Private Key"
    echo "4. Save as serviceAccountKey.json in this directory"
    echo ""
    exit 1
fi

echo "[2/5] Found serviceAccountKey.json"
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "[3/5] Creating virtual environment..."
    python3 -m venv venv
    echo ""
else
    echo "[3/5] Virtual environment already exists"
    echo ""
fi

# Activate virtual environment
echo "[4/5] Activating virtual environment..."
source venv/bin/activate
echo ""

# Install requirements
echo "[5/5] Installing dependencies..."
pip install -r requirements.txt --quiet
echo ""

echo "================================================"
echo " Setup Complete!"
echo "================================================"
echo ""
echo "You can now:"
echo "  1. Test Firebase: python test_firebase.py"
echo "  2. Populate DB:   python populate_database.py"
echo "  3. Start API:     python api.py"
echo ""
echo "To activate environment manually: source venv/bin/activate"
echo ""
