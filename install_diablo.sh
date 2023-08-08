#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

wget https://github.com/diasurgical/devilutionX/releases/download/1.5.0/devilutionx-linux-aarch64.tar.xz
mkdir ~/devilutionx
tar -xvf devilutionx-linux-aarch64.tar.xz  -C ~/devilutionx
mv devilutionx $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/opt/

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=DevilutionX
Comment=
Exec=proot-distro login debian --user phoenixbyrd --shared-tmp -- env DISPLAY=:1.0 /opt/devilutionx/devilutionx
Icon=Diablo
Path=
Terminal=false
StartupNotify=true
" > $HOME/Desktop/diablo.desktop

chmod +x $HOME/Desktop/diablo.desktop
cp $HOME/Desktop/diablo.desktop $HOME/../usr/share/applications/diablo.desktop