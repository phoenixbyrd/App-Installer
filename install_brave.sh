#!/bin/bash

varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv brave-browser-archive-keyring.gpg /usr/share/keyrings
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/phoenixbyrd/App-Installer/raw/main/brave-browser-release.list
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv brave-browser-release.list /etc/apt/sources.list.d
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt update
proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install brave-browser -y

echo "[Desktop Entry]
Version=1.0
Name=Brave Web Browser
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=3.0 /usr/bin/brave-browser-stable %U --no-sandbox
StartupNotify=true
Terminal=false
Icon=brave-browser
Type=Application
Categories=Network;WebBrowser;
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ipfs;x-scheme-handler/ipns;
Actions=new-window;new-private-window;
Path=
[Desktop Action new-window]
Name=New Window
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/bin/brave-browser-stable
[Desktop Action new-private-window]
Name=New Incognito Window
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/bin/brave-browser-stable --incognito
" > $HOME/Desktop/brave.desktop

chmod +x $HOME/Desktop/brave.desktop
cp $HOME/Desktop/brave.desktop $HOME/../usr/share/applications/brave.desktop 
