#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt update
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget https://packages.microsoft.com/repos/code/pool/main/c/code/code_1.82.0-1694038208_arm64.deb -O code.deb
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install ./code.deb -y
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 rm code.deb
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install gpg software-properties-common apt-transport-https -y
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt-key add -

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Comment=Code Editing. Redefined.
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/share/code/code --no-sandbox
Icon=visual-studio-code
Categories=Development;
Path=
Terminal=false
StartupNotify=false

" > $HOME/Desktop/code.desktop

chmod +x $HOME/Desktop/code.desktop
cp $HOME/Desktop/code.desktop $HOME/../usr/share/applications/code.desktop 
