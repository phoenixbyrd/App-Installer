sudo apt update -y
sudo apt install gpg -y 

wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg

wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 

sudo apt update -y
sudo apt install box64-android -y

dpkg --add-architecture armhf
sudo apt update -y
sudo apt install libc6:armhf -y
sudo apt install box86-android:armhf -y

sudo apt install nano cabextract libfreetype6 libfreetype6:armhf libfontconfig libfontconfig:armhf libxext6 libxext6:armhf libxinerama-dev libxinerama-dev:armhf libxxf86vm1 libxxf86vm1:armhf libxrender1 libxrender1:armhf libxcomposite1 libxcomposite1:armhf libxrandr2 libxrandr2:armhf libxi6 libxi6:armhf libxcursor1 libxcursor1:armhf libvulkan-dev libvulkan-dev:armhf -y

cd ~/
wget https://github.com/Kron4ek/Wine-Builds/releases/download/8.15/wine-8.15-amd64.tar.xz
wget https://github.com/Kron4ek/Wine-Builds/releases/download/8.15/wine-8.15-x86.tar.xz
tar xvf wine-8.15-amd64.tar.xz
tar xvf wine-8.15-x86.tar.xz
rm wine-8.15-amd64.tar.xz wine-8.15-x86.tar.xz
mv wine-8.15-amd64 wine64
mv wine-8.15-x86 wine

echo '#!/bin/bash 
export WINEPREFIX=~/.wine32
export DISPLAY=:1
box86 '"$HOME/wine/bin/wine "'"$@"' > /usr/local/bin/wine
chmod +x /usr/local/bin/wine
echo '#!/bin/bash 
export WINEPREFIX=~/.wine64
export DISPLAY=:1
box64 '"$HOME/wine64/bin/wine64 "'"$@"' > /usr/local/bin/wine64
chmod +x /usr/local/bin/wine64

WINEPREFIX=~/.wine32 box86 wine winecfg
WINEPREFIX=~/.wine64 box64 wine64 winecfg



