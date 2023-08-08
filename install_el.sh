#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://www.eternal-lands.com/EternalLands-Linux-Installer_1.9.6.1.sh
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x EternalLands-Linux-Installer_1.9.6.1.sh
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 xfce4-terminal -e ./EternalLands-Linux-Installer_1.9.6.1.sh
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm EternalLands-Linux-Installer_1.9.6.1.sh

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Eternal Lands
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 eternallands/./eternallands.sh 
Icon=eternallands
Categories=Game;
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/el.desktop

chmod +x $HOME/Desktop/el.desktop
cp $HOME/Desktop/el.desktop $HOME/../usr/share/applications/el.desktop
