#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install libsdl2-image-2.0-0 libsodium23 -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/diasurgical/devilutionX/releases/download/1.5.0/devilutionx-linux-aarch64.tar.xz
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mkdir -p devilutionx
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 tar -xvf devilutionx-linux-aarch64.tar.xz  -C devilutionx
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv devilutionx /opt
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm devilutionx-linux-aarch64.tar.xz

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=DevilutionX
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /opt/devilutionx/devilutionx
Icon=Diablo
Categories=Game;
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/diablo.desktop

chmod +x $HOME/Desktop/diablo.desktop
cp $HOME/Desktop/diablo.desktop $HOME/../usr/share/applications/diablo.desktop
