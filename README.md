# SocialDown

**The Ultimate Social Media Video & Audio Downloader**

SocialDown is a powerful, lightweight, and versatile tool designed to download videos and audio from YouTube (including playlists), Facebook, Instagram, Twitter/X, Reddit, and countless other platforms. Built for both **Windows** and **Android (Termux)**, it ensures you get the highest quality content with zero hassle.

---

## 🚀 Key Features

*   **Multi-Platform Support**: Works seamlessly on **Windows** and **Android (Termux)**.
*   **High-Quality Downloads**: Supports resolutions up to **4K** (2160p), 2K, 1080p, 720p, and more.
*   **Audio Extraction**: Easily convert and download videos as audio (MP3, M4A, AAC, etc.).
*   **Smart Engine**: Powered by `yt-dlp` and `ffmpeg` for maximum compatibility.
*   **Turbo Speed**: Integrates with **aria2c** for accelerated download speeds (Auto-configured on Windows).
*   **Playlist Support**: Download entire playlists with a single link.
*   **Metadata Embedding**: Automatically adds thumbnails and metadata to your files.
*   **User-Friendly**: 
    *   **Windows**: Interactive CLI with a desktop shortcut.
    *   **Termux**: "Share to Termux" support for instant downloads.

---

## 📥 Installation

### 💻 Windows

Getting started on Windows is effortless. The included installer handles everything for you.

1.  **Download the Source Code**: Clone this repository or download the ZIP file and extract it.
2.  **Run Installer**: Double-click on `install.bat`.
    *   It will automatically install necessary Python libraries.
    *   It will set up **aria2c** for faster downloads.
    *   It will create a **SocialDown** shortcut on your Desktop.
3.  **Start Downloading**: Open the `SocialDown` shortcut from your Desktop and paste your link!

> **Note**: Python and FFMPEG should be installed on your system. If not, the script will guide you or you can install them manually.

### 📱 Android (Termux)

Turn your phone into a downloading powerhouse.

1.  **Install Termux**: Download from [F-Droid](https://f-droid.org/en/packages/com.termux/).
2.  **Run Setup Commands**: Open Termux and copy-paste the following commands:

    ```bash
    pkg update -y && pkg upgrade -y
    pkg install git python ffmpeg aria2 -y
    termux-setup-storage
    git clone https://github.com/ZapLogic/SocialDown.git
    cd SocialDown
    chmod +x install.sh
    ./install.sh
    ```

3.  **Usage**: 
    *   **Option A**: Open a video in YouTube/App -> Share -> Termux.
    *   **Option B**: Open Termux and run `python SocialDown.py`.

---

## 🛠️ Usage Guide

**Interactive Mode**:
Simply run the script, and it will ask for the link.

**Video Quality Selection**:
When downloading YouTube videos, you can choose your preferred quality:
*   `1` - 4k (2160p)
*   `2` - 2k (1440p)
*   `3` - 1080p (Full HD)
*   `5` - 480p (Default/Data Saver)
*   `a` - Audio Only

**Command Line Arguments**:
You can also pass the link directly:
```bash
python SocialDown.py "https://www.youtube.com/watch?v=example"
```

---

## 🌐 Connect with Us

Stay updated with our latest tools and projects. **Engineered by Qadeer.**

*   🔗 **All Links**: [Linktree](https://linktr.ee/Engineer.Qadeer)
*   💻 **GitHub**: [ZapLogic](https://github.com/ZapLogic)
*   📘 **Facebook**: [Engineer Qadeer](https://facebook.com/Engineer.Qadeer)
*   📺 **YouTube**: [@Engineer.Qadeer](https://youtube.com/@Engineer.Qadeer)

---

© 2025 **ZapLogic**. All rights reserved.
