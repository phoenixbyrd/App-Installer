#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://remarkableapp.github.io/files/remarkable_1.87_all.deb
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install ./remarkable_1.87_all.deb -y

# Create the desktop entry
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Remarkable
Comment=
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 remarkable
Icon=remarkable
Categories=Office;
Path=
Terminal=false
StartupNotify=false

" > $HOME/Desktop/remarkable.desktop

chmod +x $HOME/Desktop/remarkable.desktop
cp $HOME/Desktop/remarkable.desktop $HOME/../usr/share/applications/remarkable.desktop
