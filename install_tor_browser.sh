#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

cd

# Installation steps for Tor Browser
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install firefox-esr -y
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 curl -sLO https://sourceforge.net/projects/tor-browser-ports/files/12.5.1/tor-browser-linux-arm64-12.5.1_ALL.tar.xz/download
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv download tor.tar.xz
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 tar -xvf tor.tar.xz
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm tor.tar.xz

# Create the desktop entry
echo "[Desktop Entry]
Type=Application
Name=Tor Browser
GenericName=Web Browser
Comment=Tor Browser is +1 for privacy and −1 for mass surveillance
Categories=Network;WebBrowser;Security;
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0  tor-browser/Browser/start-tor-browser
X-TorBrowser-ExecShell=./Browser/start-tor-browser --detach
Icon=tor
StartupWMClass=Tor Browser
Path=
Terminal=false
StartupNotify=false
" > $HOME/Desktop/tor.desktop

chmod +x $HOME/Desktop/tor.desktop
cp $HOME/Desktop/tor.desktop $HOME/../usr/share/applications/tor.desktop
