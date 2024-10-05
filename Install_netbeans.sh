#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)
package="https://github.com/codelerity/netbeans-installers/releases/download/v23-build1/apache-netbeans_23-1_arm64.deb" 

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt update

#download
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget $package -O netbeans.deb
#if downloading takes too long with wget try using this
#proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt install aria2
#proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 aria2c -x5 -o netbeans.deb "$package"

#instalation
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 dpkg -i netbeans.deb
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 rm netbeans.deb

# Create the desktop entry
echo "[Desktop Entry]
Name=Apache Netbeans
Comment=IDE Java
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 netbeans
Icon=netbeans
Type=Application
StartupNotify=true
Categories=Development;
Path=
Terminal=false
" > $HOME/Desktop/netbeans.desktop

chmod +x $HOME/Desktop/netbeans.desktop
cp $HOME/Desktop/netbeans.desktop $HOME/../usr/share/applications/netbeans.desktop
