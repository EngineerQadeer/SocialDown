# SocialDown v1.1 - Optimized & Refactored

import os
import sys
import json
import shutil
import platform
import urllib.request
import zipfile
from urllib.parse import urlparse
from pathlib import Path

# Global configurations
is_windows = platform.system().lower() == 'windows'
has_aria2c = False
json_path = ""
genPath = ""

def setup_environment():
    global has_aria2c, json_path, genPath
    
    if is_windows:
        print("="*50)
        print("SocialDown Script - Created by Engineer Qadeer")
        print("Join us on Social Media")
        print("Github:   https://github.com/EngineerQadeer")
        print("Facebook: https://facebook.com/Engineer.Qadeer")
        print("Youtube:  https://youtube.com/@Engineer.Qadeer")
        print("="*50)

        home_dir = str(Path.home())
        json_path = os.path.join(home_dir, ".socialdown_config.json")
        genPath = os.path.join(home_dir, "Downloads") + os.sep
        has_aria2c = shutil.which('aria2c') is not None
        print(f"Aria2c detected: {has_aria2c}")
    else:
        # Termux defaults
        json_path = "/data/data/com.termux/files/home/default.json"
        genPath = "/storage/emulated/0/"
        has_aria2c = shutil.which('aria2c') is not None or True # Assumed for Termux
        
    init_config()

def init_config():
    if not os.path.isfile(json_path):
        jsonnew = {
            "default": [
                {"code": "", "codec": ""}
            ],
            "1": [{"height": "2160", "res": "4k"}],
            "2": [{"height": "1440", "res": "2k"}],
            "3": [{"height": "1080", "res": "1080p"}],
            "4": [{"height": "720", "res": "720p"}],
            "5": [{"height": "480", "res": "480p"}],
            "6": [{"height": "360", "res": "360p"}],
            "7": [{"height": "240", "res": "240p"}],
            "8": [{"height": "144", "res": "144p"}]
        }
        with open(json_path, "w") as out:
            json.dump(jsonnew, out, indent=4)

def check_and_download_ffmpeg():
    if is_windows:
        has_ffmpeg = shutil.which('ffmpeg') is not None or os.path.exists('ffmpeg.exe')
        has_ffprobe = shutil.which('ffprobe') is not None or os.path.exists('ffprobe.exe')
        
        if not (has_ffmpeg and has_ffprobe):
            print("FFmpeg/FFprobe not found. Downloading essential binaries (this will only happen once)...")
            try:
                url = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
                zip_path = "ffmpeg.zip"
                urllib.request.urlretrieve(url, zip_path)
                print("Extracting FFmpeg...")
                with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                    for file in zip_ref.namelist():
                        if file.endswith("ffmpeg.exe") or file.endswith("ffprobe.exe"):
                            source = zip_ref.open(file)
                            filename = os.path.basename(file)
                            with open(filename, "wb") as target:
                                shutil.copyfileobj(source, target)
                os.remove(zip_path)
                print("FFmpeg setup complete.")
            except Exception as e:
                print(f"Failed to download FFmpeg: {e}")
                print("Please download FFmpeg manually and place ffmpeg.exe and ffprobe.exe in this folder.")

def install_dependencies():
    try:
        import yt_dlp
    except ModuleNotFoundError:
        print("Installing yt_dlp...")
        os.system('pip install --no-deps -U yt_dlp')

def get_config():
    with open(json_path, "r") as f:
        return json.load(f)

def save_config(data):
    with open(json_path, "w") as f:
        json.dump(data, f, indent=4)

def downloader(url, opt):
    import yt_dlp
    
    # Create a hidden temp folder for intermediate files
    temp_dir = os.path.join(genPath, 'SocialDown', '.temp_downloads')
    if not os.path.exists(temp_dir):
        os.makedirs(temp_dir, exist_ok=True)
        if is_windows:
            try:
                import ctypes
                # 0x02 is the hidden attribute on Windows
                ctypes.windll.kernel32.SetFileAttributesW(temp_dir, 0x02)
            except Exception:
                pass
                
    if 'paths' not in opt:
        opt['paths'] = {}
    opt['paths']['temp'] = temp_dir
    
    # Global Speed Optimizations
    opt['concurrent_fragment_downloads'] = 10  # Speed up m3u8/dash downloads
    
    # Add aria2c for parallel downloading if available
    if has_aria2c:
        opt['external_downloader'] = 'aria2c'
        opt['external_downloader_args'] = {
            # Use 16 connections per server and 16 split connections for maximum speed
            'aria2c': ['-c', '-j', '16', '-x', '16', '-s', '16', '-k', '1M']
        }
        
    with yt_dlp.YoutubeDL(opt) as yt:
        yt.extract_info(url, download=True)

def youtube_flow(url):
    print("Select download option:")
    print("1 - 4k\n2 - 2k\n3 - 1080p\n4 - 720p\n5 - 480p (default)\n6 - 360p\n7 - 240p\n8 - 144p\na - Audio only")
    choice = input("Enter code (1-8) for video quality or 'a' for audio (default 480p): ").strip()
    
    if choice == "a":
        audio_download(url)
        return
        
    if choice not in ["1","2","3","4","5","6","7","8"]:
        choice = "5"  # default 480p
        
    data = get_config()
    height = data[choice][0]["height"]
    
    if "playlist" in url:
        path = os.path.join(genPath, 'SocialDown', 'Youtube', '%(playlist)s', '%(title)s.%(ext)s')
    else:
        path = os.path.join(genPath, 'SocialDown', 'Youtube', '%(title)s.%(ext)s')
        
    sub = input("Download subtitle? (y/n): ").lower() == "y"
    
    opt = {
        'outtmpl': path,
        'writesubtitles': sub,
        'writeautomaticsub': sub,
        'merge_output_format': 'mp4',
        'writethumbnail': True,
        'format': f'bestvideo[height<={height}]+bestaudio[ext=m4a]/best[height<={height}]/best[ext=m4a]',
        'postprocessors': [
            {'key': 'FFmpegEmbedSubtitle', 'already_have_subtitle': False},
            {'key': 'FFmpegMetadata', 'add_metadata': True},
            {'key': 'EmbedThumbnail', 'already_have_thumbnail': False}
        ]
    }
    
    downloader(url, opt)

def audio_download(url):
    data = get_config()
    codec = data["default"][0]["codec"]
    
    if not codec:
        codec = input('Enter audio format (mp3, aac, m4a, flac...): ').strip() or "mp3"
        data["default"][0]["codec"] = codec
        save_config(data)
    
    audio_dir = os.path.join(genPath, "SocialDown", "Youtube", "Audio")
    os.makedirs(audio_dir, exist_ok=True)
    
    if "playlist" in url:
        op_path = os.path.join(audio_dir, '%(playlist)s', '%(title)s.%(ext)s')
    else:
        op_path = os.path.join(audio_dir, '%(title)s.%(ext)s')
        
    opt = {
        'format': 'bestaudio/best',
        'writethumbnail': True,
        'ignoreerrors': True,
        'outtmpl': op_path,
        'postprocessors': [
            {'key': 'FFmpegExtractAudio', 'preferredcodec': codec},
            {'key': 'FFmpegMetadata', 'add_metadata': True},
            {'key': 'EmbedThumbnail', 'already_have_thumbnail': False}
        ]
    }
    
    downloader(url, opt)

def others(url):
    # Better URL Parsing to get accurate Site Names
    parsed_url = urlparse(url)
    domain = parsed_url.netloc
    if domain.startswith("www."):
        domain = domain[4:]
    dir_name = domain.split('.')[0].capitalize() if domain else "Unknown"
    
    path_dir = os.path.join(genPath, 'SocialDown', dir_name)
    os.makedirs(path_dir, exist_ok=True)
    
    opt = {
        'outtmpl': os.path.join(path_dir, "%(title).50s.%(ext)s"),
        'writesubtitles': True,
        'writeautomaticsub': True,
    }
    
    try:
        downloader(url, opt)
    except Exception as e:
        print(f"Download failed for {url}: {e}")
        # Only remove directory if it is empty to avoid accidentally deleting valid downloads
        try:
            os.rmdir(path_dir)
        except OSError:
            pass

def process_url(url):
    if "youtube.com" in url or "youtu.be" in url:
        youtube_flow(url)
    else:
        others(url)

def main():
    setup_environment()
    check_and_download_ffmpeg()
    install_dependencies()

    # CLI / Argument based flow
    if len(sys.argv) > 1:
        url = sys.argv[1]
        process_url(url)
        if is_windows:
             input("\nPress Enter to exit...")
             
    # Interactive mode for Windows
    elif is_windows:
        while True:
            try:
                print("\n" + "="*50)
                url = input("Enter link to download (or 'q' to exit): ").strip()
                if url.lower() in ['q', 'quit', 'exit']:
                    break
                if not url:
                    continue
                process_url(url)
                print("Download finished!")
            except KeyboardInterrupt:
                break
            except Exception as e:
                print(f"An error occurred: {e}")
                
    # Termux / Standard Interactive (Run once)
    else:
        url = input("Enter the link to download: ").strip()
        if not url:
            print("No link provided. Exiting.")
            sys.exit(1)
        process_url(url)

if __name__ == "__main__":
    main()
