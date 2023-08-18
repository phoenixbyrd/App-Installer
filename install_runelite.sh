#!/bin/bash

varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

#Install Obsidian

proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 sudo apt install zlib1g-dev pulseaudio-module-jack pulseaudio -y
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/runelite/launcher/releases/download/2.6.8/RuneLite-aarch64.AppImage
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 chmod +x RuneLite-aarch64.AppImage
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 ./RuneLite-aarch64.AppImage --appimage-extract
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 mv squashfs-root /opt/RuneLite
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 rm RuneLite-aarch64.AppImage



#Create Desktop Launcher

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=RuneLite
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /opt/RuneLite/./RuneLite
Icon=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/opt/RuneLite/runelite.png
Categories=Game;
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/runelite.desktop

chmod +x $HOME/Desktop/runelite.desktop
cp $HOME/Desktop/runelite.desktop $HOME/../usr/share/applications/runelite.desktop 
