#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 apt update
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/SpacingBat3/WebCord/releases/download/v4.8.0/webcord_4.8.0_arm64.deb
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install ./webcord_4.8.0_arm64.deb -y
proot-distro login --user $varname debian --shared-tmp -- env DISPLAY=:1.0 rm webcord_4.8.0_arm64.deb

echo "[Desktop Entry]
Name=Discord
Comment=A Discord and Fosscord client made with the Electron API.
GenericName=Internet Messenger
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 webcord --no-sandbox
Icon=discord
Type=Application
StartupNotify=true
Categories=Network;InstantMessaging;
" > $HOME/Desktop/webcord.desktop

chmod +x $HOME/Desktop/webcord.desktop
cp $HOME/Desktop/webcord.desktop $HOME/../usr/share/applications/webcord.desktop 
