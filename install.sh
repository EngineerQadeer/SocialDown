#!/bin/bash

echo "=========================================="
echo "     SocialDown Termux Installer"
echo "=========================================="

# 1. Setup Directories
INSTALL_DIR="/data/data/com.termux/files/home/SocialDown"
BIN_DIR="/data/data/com.termux/files/home/bin"

echo "[1/4] Creating installation directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# 2. Copy Files
echo "[2/4] Copying files to $INSTALL_DIR..."
cp "SocialDown.py" "$INSTALL_DIR/SocialDown.py"
cp "requirements.txt" "$INSTALL_DIR/requirements.txt"

# 3. Create the termux-url-opener script
echo "[3/4] Setting up termux-url-opener..."
cat > "$BIN_DIR/termux-url-opener" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
python /data/data/com.termux/files/home/SocialDown/SocialDown.py "$1"
EOF

chmod +x "$BIN_DIR/termux-url-opener"

# 4. Storage permissions & Dependencies
echo "[4/4] Requesting storage access and installing dependencies..."
termux-setup-storage

# Update packages and install core tools (ffmpeg, aria2, python)
pkg update -y
pkg install python aria2 ffmpeg -y

# Install Python requirements
pip install -r "$INSTALL_DIR/requirements.txt"

clear
echo "=========================================="
echo "      SocialDown installation complete!"
echo "=========================================="
echo "- Script is installed in: $INSTALL_DIR"
echo "- Dependencies (yt-dlp, ffmpeg, aria2) are installed."
echo "- You can now share media links directly to Termux,"
echo "- Or run manually: python ~/SocialDown/SocialDown.py <link>"
echo ""
