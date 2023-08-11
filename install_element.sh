#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install -y wget apt-transport-https -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo tee /etc/apt/sources.list.d/element-io.list
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt update
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install element-desktop -y

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Element
Comment=A secure communications platform 
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 element-desktop --no-sandbox
Icon=element
Categories=Network;
Path=
Terminal=false
StartupNotify=true

" > $HOME/Desktop/element.desktop

chmod +x $HOME/Desktop/element.desktop
cp $HOME/Desktop/element.desktop $HOME/../usr/share/applications/element.desktop 
