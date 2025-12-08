@echo off
setlocal EnableDelayedExpansion
title SocialDown Installer

echo ==========================================
echo      SocialDown Installer for Windows
echo ==========================================
echo.

:: Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in your PATH.
    echo Please install Python from python.org and try again.
    pause
    exit /b
)

echo [1/3] Installing requirements...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install requirements.
    pause
    exit /b
)
echo Requirements installed successfully.
echo.

echo [2/3] Installing aria2c...
if exist "%~dp0aria2c.exe" (
    for /f "delims=" %%i in ('python -c "import sys, os; print(os.path.join(sys.prefix, 'Scripts'))"') do set "TARGET_DIR=%%i"
    echo Target Directory: !TARGET_DIR!
    if exist "!TARGET_DIR!" (
        copy /Y "%~dp0aria2c.exe" "!TARGET_DIR!\aria2c.exe" >nul
        if !errorlevel! equ 0 (
            echo [SUCCESS] aria2c installed successfully.
        ) else (
            echo [ERROR] Failed to install aria2c. Please run as Administrator.
        )
    ) else (
         echo [ERROR] Python Scripts directory not found.
    )
) else (
    echo [INFO] aria2c.exe not found in current directory.
)
echo.

echo [3/3] Creating Desktop Shortcut...
set "SCRIPT_DIR=%~dp0"
set "PYTHON_SCRIPT=%SCRIPT_DIR%SocialDown.py"
:: Use the new custom icon file (v2)
set "ICON_PATH=%SCRIPT_DIR%socialdown_v2.ico"
:: Remove trailing backslash for VBS
set "WORKING_DIR=%SCRIPT_DIR:~0,-1%"

set "VBS_SCRIPT=%temp%\create_shortcut_%random%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = oWS.ExpandEnvironmentStrings("%%USERPROFILE%%\Desktop\SocialDown.lnk") >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
:: Target is cmd /k python script.py to keep window open if it crashes, 
:: but our script loops so 'python script.py' is fine.
echo oLink.TargetPath = "python" >> "%VBS_SCRIPT%"
echo oLink.Arguments = """%PYTHON_SCRIPT%""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%WORKING_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "SocialDown Video Downloader" >> "%VBS_SCRIPT%"
echo oLink.IconLocation = "%ICON_PATH%" >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript /nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%"

echo.
echo ==========================================
echo      Installation Complete!
echo ==========================================
echo A shortcut 'SocialDown' has been created on your Desktop.
echo You can close this window now.
pause
