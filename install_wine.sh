#!/bin/bash

varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

cp $HOME/.App-Installer/wine.sh $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/$varname
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 ./wine.sh


echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Wine 32 Desktop
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 box86 wine explorer /desktop=shell,1024x768 explorer.exe
Icon=windows95
Categories=Game;
Path=
Terminal=false
StartupNotify=true" > $HOME/Desktop/wine32.desktop
chmod +x $HOME/Desktop/wine32.desktop
cp $HOME/Desktop/wine32.desktop $HOME/../usr/share/applications

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Wine 64 Desktop
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 box64 wine explorer /desktop=shell,1024x768 explorer.exe
Icon=windows95
Categories=Game;
Path=
Terminal=false
StartupNotify=true" > $HOME/Desktop/wine64.desktop
chmod +x $HOME/Desktop/wine64.desktop
cp $HOME/Desktop/wine64.desktop $HOME/../usr/share/applications

rm $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/$varname/wine.sh
