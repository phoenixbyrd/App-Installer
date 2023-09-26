#!/bin/bash

#This script installs aarch64 .tar.xz or .tar.gz into debian proot /opt directory and creates a desktop and menu launcher

# Default values to edit
#Enter URL to appimage
url="https://github.com/phoenixbyrd/App-Installer/raw/main/lagrange.tar.gz"
#Enter name of app
appname="lagrange"
#Enter path to icon or system icon name
icon_path="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/opt/lagrange/lagrange.png"
#Enter Categories for .desktop
category="Network"
#Enter any dependencies
depends="libsdl2-2.0-0"

#Do not edit below here unless required
# Process command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --install)
            install=true
            shift
            ;;
        --uninstall)
            uninstall=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ "$install" = true ]; then
    download="wget $url"
    strip="--strip-components=1"
    extract="tar -xzf ${url##*/} -C $appname" #-xvf if tar.xz or -xzf if tar.gz 
    dir="/opt/$appname"
    install="prun sudo apt install -y "

    varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)
    prun="proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 $@"

    $prun $download
    $prun mkdir -p $appname
    $prun $extract
    $install $depends	
    prun mv $appname $dir
    prun rm ${url##*/}

    installed_dir="$HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/$dir"
    desktop_file="$HOME/Desktop/$appname.desktop"
    binary=$(find "$installed_dir" -type f -executable -print -quit)

    #If binary is different, specify it here after $installed_dir/ and use $alt_binary instead of $binary
    alt_binary="$installed_dir/"

    #If binary is sandboxed use $sandboxed at end of Exec command
    sandboxed="--no-sandbox"

#NOTE: Do not remove prun from Exec command
cat > "$desktop_file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=$appname
Exec=prun $binary
Icon=$icon_path
Categories=$category
Terminal=false
EOL

chmod +x "$desktop_file"
cp "$desktop_file" $HOME/../usr/share/applications
echo "Installation completed."

elif [ "$uninstall" = true ]; then
    echo "Uninstalling..."
    dir="/opt/$appname"
    installed_dir="$HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/$dir"
    rm -rf "$installed_dir"
    desktop_file="$HOME/Desktop/$appname.desktop"
    rm "$desktop_file"
    rm "$HOME/../usr/share/applications/$appname.desktop"

    echo "Uninstallation completed."
else
    echo "No valid option provided. Use --install or --uninstall."
    exit 1
fi
