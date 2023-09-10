#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

#Install Box86 and Box64

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo dpkg --add-architecture armhf

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt update -y

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install box64-android libc6 libc6:armhf box86-android:armhf -y

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt install -y cabextract libfreetype6 libfreetype6:armhf libfontconfig libfontconfig:armhf libxext6 libxext6:armhf libxinerama-dev libxinerama-dev:armhf libxxf86vm1 libxxf86vm1:armhf libxrender1 libxrender1:armhf libxcomposite1 libxcomposite1:armhf libxrandr2 libxrandr2:armhf libxi6 libxi6:armhf libxcursor1 libxcursor1:armhf libvulkan-dev libvulkan-dev:armhf libgnutls30 libgnutls30:armhf libasound2:armhf libglib2.0-0:armhf libgphoto2-6:armhf libgphoto2-port12:armhf libgstreamer-plugins-base1.0-0:armhf libgstreamer1.0-0:armhf libldap-common libldap-common:armhf libopenal1 libopenal1:armhf libpcap0.8:armhf libpulse0 libpulse0:armhf libsane1:armhf libudev1:armhf libusb-1.0-0:armhf libvkd3d1:armhf libx11-6:armhf libasound2-plugins:armhf ocl-icd-libopencl1:armhf libncurses6:armhf libncurses5:armhf libcap2-bin:armhf libcups2:armhf libdbus-1-3:armhf libfontconfig1:armhf libglu1-mesa:armhf libglu1:armhf libgssapi-krb5-2:armhf libkrb5-3:armhf libodbc1:armhf libosmesa6:armhf libsdl2-2.0-0:armhf libv4l-0:armhf libxfixes3:armhf libxinerama1:armhf

#Install Wine

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/Kron4ek/Wine-Builds/releases/download/8.13/wine-8.13-x86.tar.xz

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/Kron4ek/Wine-Builds/releases/download/8.13/wine-8.13-amd64.tar.xz

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 tar xvf wine-8.13-x86.tar.xz

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 tar xvf wine-8.13-amd64.tar.xz

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm wine-8.13-x86.tar.xz wine-8.13-amd64.tar.xz

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv wine-8.13-x86 wine

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv wine-8.13-amd64 wine64

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 echo '
export BOX86_PATH=~/wine/bin/
export BOX86_LD_LIBRARY_PATH=~/wine/lib/wine/i386-unix/:/lib/i386-linux-gnu/:/lib/aarch64-linux-gnu/:/lib/arm-linux-gnueabihf/:/usr/lib/aarch64-linux-gnu/:/usr/lib/arm-linux-gnueabihf/:/usr/lib/i386-linux-gnu/
export BOX64_PATH=~/wine64/bin/
export BOX64_LD_LIBRARY_PATH=~/wine64/lib/i386-unix/:wine64/lib/wine/x86_64-unix/:/lib/i386-linux-gnu/:/lib/x86_64-linux-gnu:/lib/aarch64-linux-gnu/:/lib/arm-linux-gnueabihf/:/usr/lib/aarch64-linux-gnu/:/usr/lib/arm-linux-gnueabihf/:/usr/lib/i386-linux-gnu/:/usr/lib/x86_64-linux-gnu' >> .bashrc

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 source .bashrc

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 echo '#!/bin/bash 
export WINEPREFIX=~/.wine32
box86 '"~/wine/bin/wine "'"$@"' > /usr/local/bin/wine

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x /usr/local/bin/wine

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 echo '#!/bin/bash 
export WINEPREFIX=~/.wine64
box64 '"~/wine64/bin/wine64 "'"$@"' > /usr/local/bin/wine64

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x /usr/local/bin/wine64

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wine wineboot

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wine64 wineboot

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x winetricks

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 mv winetricks /usr/local/bin/

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 echo '#!/bin/bash 
export BOX86_NOBANNER=1 WINE=wine WINEPREFIX=~/.wine32 WINESERVER=~/wine/bin/wineserver
wine '"/usr/local/bin/winetricks "'"$@"' > /usr/local/bin/winetricks32

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x /usr/local/bin/winetricks32

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 echo '#!/bin/bash 
export BOX64_NOBANNER=1 WINE=wine64 WINEPREFIX=~/.wine64 WINESERVER=~/wine64/bin/wineserver
wine64 '"/usr/local/bin/winetricks "'"$@"' > /usr/local/bin/winetricks64

proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 chmod +x /usr/local/bin/winetricks64





