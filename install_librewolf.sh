#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install libdbus-glib-1-2 zlib1g-dev -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/116.0-1/LibreWolf.aarch64.AppImage
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x LibreWolf.aarch64.AppImage
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 ./LibreWolf.aarch64.AppImage --appimage-extract
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv squashfs-root /opt/librewolf
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm LibreWolf.aarch64.AppImage

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=LibreWolf
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /opt/librewolf/./librewolf
Icon=librewolf
Categories=Network;
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/librewolf.desktop

chmod +x $HOME/Desktop/librewolf.desktop
cp $HOME/Desktop/librewolf.desktop $HOME/../usr/share/applications/librewolf.desktop
