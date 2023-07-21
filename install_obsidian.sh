#!/bin/bash

varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

#Install Obsidian

proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 sudo apt install zlib1g-dev
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.3.5/Obsidian-1.3.5-arm64.AppImage
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0  chmod +x Obsidian-1.3.5-arm64.AppImage
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0  ./Obsidian-1.3.5-arm64.AppImage --appimage-extract
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0  mv squashfs-root obsidian
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0  rm Obsidian-1.3.5-arm64.AppImage



#Create Desktop Launcher

echo "[Desktop Entry]
Version=1.0
Name=Obsidian
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 GALLIUM_DRIVER=virpipe obsidian/./obsidian --no-sandbox
StartupNotify=true
Terminal=false
Icon=obsidian
Type=Application
Categories=Development;
" > $HOME/Desktop/obsidian.desktop

chmod +x $HOME/Desktop/obsidian.desktop
cp $HOME/Desktop/obsidian.desktop $HOME/../usr/share/applications/obsidian.desktop 
