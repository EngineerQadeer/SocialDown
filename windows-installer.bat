@echo off
setlocal EnableDelayedExpansion
title SocialDown Setup

echo ==========================================
echo      SocialDown System Installer
echo ==========================================
echo.

:: 1. Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in your PATH.
    echo Please install Python from python.org and try again.
    pause
    exit /b
)

:: 2. Setup Directories
set "INSTALL_DIR=%USERPROFILE%\SocialDown"
echo [1/4] Creating installation directory at %INSTALL_DIR%
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 3. Copy Files
echo [2/4] Copying files...
copy /Y "%~dp0SocialDown.py" "%INSTALL_DIR%\SocialDown.py" >nul
copy /Y "%~dp0requirements.txt" "%INSTALL_DIR%\requirements.txt" >nul
if exist "%~dp0aria2c.exe" copy /Y "%~dp0aria2c.exe" "%INSTALL_DIR%\aria2c.exe" >nul
if exist "%~dp0socialdown_v2.ico" copy /Y "%~dp0socialdown_v2.ico" "%INSTALL_DIR%\socialdown_v2.ico" >nul

:: 4. Install Dependencies & Setup FFmpeg
echo.
echo [3/4] Installing dependencies and setting up FFmpeg...
cd /d "%INSTALL_DIR%"
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install requirements.
    pause
    exit /b
)
:: Run the script silently just to trigger the FFmpeg download function
python -c "import SocialDown; SocialDown.check_and_download_ffmpeg()"

:: 5. Add to PATH
echo.
echo [4/4] Adding SocialDown to System PATH...
:: Use PowerShell to safely append to User PATH without duplicating System PATH
powershell -Command "$userPath = [Environment]::GetEnvironmentVariable('Path', 'User'); if ($userPath -notlike '*%INSTALL_DIR%*') { [Environment]::SetEnvironmentVariable('Path', $userPath + ';%INSTALL_DIR%', 'User'); Write-Host 'Path updated successfully.' } else { Write-Host 'Path already exists.' }"

:: 6. Create Desktop Shortcut
echo.
echo Creating Desktop Shortcut...
set "PYTHON_SCRIPT=%INSTALL_DIR%\SocialDown.py"
set "ICON_PATH=%INSTALL_DIR%\socialdown_v2.ico"
set "WORKING_DIR=%INSTALL_DIR%"
set "VBS_SCRIPT=%temp%\create_shortcut_%random%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = oWS.ExpandEnvironmentStrings("%%USERPROFILE%%\Desktop\SocialDown.lnk") >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "python" >> "%VBS_SCRIPT%"
echo oLink.Arguments = """%PYTHON_SCRIPT%""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%WORKING_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "SocialDown Video Downloader" >> "%VBS_SCRIPT%"
if exist "%ICON_PATH%" echo oLink.IconLocation = "%ICON_PATH%" >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript /nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%"

echo.
echo ==========================================
echo      Installation Complete!
echo ==========================================
echo - SocialDown is installed in: %INSTALL_DIR%
echo - FFmpeg, aria2c, and dependencies are ready.
echo - Shortcut created on your Desktop.
echo - Folder added to PATH (Please restart CMD/Terminal to use anywhere).
echo.
pause
