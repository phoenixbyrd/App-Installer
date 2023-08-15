#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install openjdk-17-jre -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt -f install 
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install libopenal1 zlib1g-dev -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/gl91306/lunar/releases/download/v2.10.1.bruh/lunarclient-2.10.1-arm64.AppImage
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x lunarclient-2.10.1-arm64.AppImage
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 ./lunarclient-2.10.1-arm64.AppImage --appimage-extract
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv squashfs-root/ /opt/lunarclient
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm lunarclient-2.10.1-arm64.AppImage

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=LunarClient
Comment=free all-in-one modpack available on all versions of Minecraft 
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=3.0 /opt/lunarclient/./lunarclient --no-sandbox
Icon=lunarclient
Categories=Game;
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/lunarclient.desktop

chmod +x $HOME/Desktop/lunarclient.desktop
cp $HOME/Desktop/lunarclient.desktop $HOME/../usr/share/applications/lunarclient.desktop
