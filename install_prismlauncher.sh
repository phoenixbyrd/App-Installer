#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install mesa-utils libopenal1 openjdk-17-jre -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/Pi-Apps-Coders/files/releases/download/large-files/prismlauncher_7.2-1_arm64.deb
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install ./prismlauncher_7.2-1_arm64.deb -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm prismlauncher_7.2-1_arm64.deb

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Prism Launcher
Comment=free all-in-one modpack available on all versions of Minecraft 
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=3.0 prismlauncher
Icon=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/usr/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg
Categories=Game;
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/prism.desktop

chmod +x $HOME/Desktop/prism.desktop
cp $HOME/Desktop/prism.desktop $HOME/../usr/share/applications/prism.desktop
