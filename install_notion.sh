#!/bin/bash

varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

#Install Obsidian

proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install zlib1g-dev -y
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/notion-enhancer/notion-repackaged/releases/download/v2.0.18-1/Notion-2.0.18-1-arm64.AppImage
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 chmod +x Notion-2.0.18-1-arm64.AppImage
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 ./Notion-2.0.18-1-arm64.AppImage --appimage-extract
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 mv squashfs-root notion
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 rm Notion-2.0.18-1-arm64.AppImage

#Create Desktop Launcher

echo "[Desktop Entry]
Version=1.0
Name=Notion
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 GALLIUM_DRIVER=virpipe notion/./notion-app --no-sandbox
StartupNotify=true
Terminal=false
Icon=notion
Type=Application
Categories=Office;
" > $HOME/Desktop/notion.desktop

chmod +x $HOME/Desktop/notion.desktop
cp $HOME/Desktop/notion.desktop $HOME/../usr/share/applications/notion.desktop 
