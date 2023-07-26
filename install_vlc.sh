#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt update
proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt install vlc -y

cp $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/usr/share/applications/vlc.desktop $HOME/../usr/share/applications
sed -i "s/^Exec=\(.*\)$/Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 \1/"   $HOME/../usr/share/applications/vlc.desktop
