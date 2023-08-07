#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt update
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt install vlc -y

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=VLC media player
Comment=Read, capture, broadcast your multimedia streams
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/bin/vlc --started-from-file %U
Icon=vlc
Categories=Video;
Path=
Terminal=false
StartupNotify=false

" > $HOME/Desktop/vlc.desktop

chmod +x $HOME/Desktop/vlc.desktop
cp $HOME/Desktop/vlc.desktop $HOME/../usr/share/applications/vlc.desktop 
