#!/bin/bash

#This script installs aarch64 appimages into debian proot /opt directory and creates a desktop and menu launcher

# Default values to edit
#Enter URL to apt repo
url="https://github.com/Stabyourself/mari0.git"
#Enter package to install
pkg="mari0"
#Enter path to icon or system icon name
icon_path="$HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/opt/mari0/graphics/icon.png"
#Enter Categories for .desktop
category="Game"
#Enter any dependencies
depends="love"

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
    
    clone="git clone $url"
    install="prun sudo apt install "
    
    varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)
    prun="proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 $@"
    installed_dir="$HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/$dir"
    desktop_file="$HOME/Desktop/$pkg.desktop"
    
    $install $depends -y
    $prun sudo dpkg --configure -a
    $prun $clone
    $prun mv mari0 /opt
    

    #If binary is sandboxed use $sandboxed at end of Exec command
    sandboxed="--no-sandbox"

#NOTE: Do not remove prun from Exec command
cat > "$desktop_file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=$pkg
Exec=prun love /opt/mari0
Icon=$icon_path
Categories=$category
Terminal=false
EOL

chmod +x "$desktop_file"
cp "$desktop_file" $HOME/../usr/share/applications
echo "Installation completed."

elif [ "$uninstall" = true ]; then
    echo "Uninstalling..."
    rm -rf $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/opt/mari0
    remove="prun sudo apt remove "
    $remove $depends -y 
    desktop_file="$HOME/Desktop/$pkg.desktop"
    rm "$desktop_file"
    rm "$HOME/../usr/share/applications/$pkg.desktop"

    echo "Uninstallation completed."
else
    echo "No valid option provided. Use --install or --uninstall."
    exit 1
fi
