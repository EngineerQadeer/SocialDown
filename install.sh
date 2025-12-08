#!/bin/bash

# Move main script to home directory
cp "SocialDown.py" "/data/data/com.termux/files/home/SocialDown.py"

# Create $HOME/bin if it doesn't exist
mkdir -p /data/data/com.termux/files/home/bin

# Create the termux-url-opener script in $HOME/bin
cat > /data/data/com.termux/files/home/bin/termux-url-opener << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
python /data/data/com.termux/files/home/SocialDown.py "$1"
EOF

chmod +x /data/data/com.termux/files/home/bin/termux-url-opener

# Storage permission
termux-setup-storage

# Install dependencies
pkg update -y
pkg install python aria2 ffmpeg -y
pip install yt-dlp

clear
echo "SocialDown installation complete!"
echo "You can now share links to Termux, or run: python SocialDown.py <link>"
