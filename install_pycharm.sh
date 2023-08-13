#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://download.jetbrains.com/python/pycharm-community-2023.2-aarch64.tar.gz -O pycharm-community.tar.gz
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install default-jdk -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S tar xzf pycharm-community.tar.gz
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S mv pycharm-community-2023.2/ /opt/pycharm-community
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S chmod +x /opt/pycharm-community/bin/pycharm.sh

# Create the desktop entry
echo "[Desktop Entry]
Name=PyCharm
Comment=A Python IDE
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /opt/pycharm-community/bin/./pycharm.sh
Icon=pycharm
Type=Application
StartupNotify=true
Categories=Development;
Path=
Terminal=false
" > $HOME/Desktop/pycharm.desktop

chmod +x $HOME/Desktop/pycharm.desktop
cp $HOME/Desktop/pycharm.desktop $HOME/../usr/share/applications/pycharm.desktop
