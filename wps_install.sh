#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# Configuration Section - Edit these values as needed
# ============================================================================

# Application Details
declare -A APP_CONFIG=(
   [url]="https://github.com/Pi-Apps-Coders/files/releases/download/large-files/wps-office_11.1.0.11720_arm64.deb"
   [name]="wps-office"
   [icon]="wpsoffice"
   [category]="Office"
   [dependencies]="ttf-mscorefonts-installer x11-utils wmctrl firejail bsdextrautils"
   [extra_flags]=""
   [description]="WPS Office Suite - Word, Presentation and Spreadsheet"
)

# System Paths
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$PREFIX/share/applications"

# ============================================================================
# Helper Functions
# ============================================================================

log() {
   echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error() {
   log "ERROR: $1" >&2
   exit 1
}

check_dependencies() {
   if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/debian" ]; then
       error "Debian proot is not installed. Please install it first."
   fi
   
   if ! command -v proot-distro >/dev/null; then
       error "proot-distro is not installed. Please install it first."
   fi
}

get_prun_command() {
   local username=$(basename "$PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/"* 2>/dev/null)
   if [ -z "$username" ]; then
       error "Failed to detect debian proot username"
   fi
   echo "proot-distro login debian --user $username --shared-tmp -- env DISPLAY=:0"
}

create_wrapper() {
   local cmd="$1"
   local old_class="$2"
   local new_class="$3"
   local prun=$(get_prun_command)
   
   $prun sudo tee "/usr/local/bin/$cmd" > /dev/null << EOF
#!/bin/bash
# Clean up desktop files
rm -f ~/Desktop/wps*.desktop ~/.local/share/applications/wps*.desktop
# Fix window class for Wayland
(for i in {0..20}; do
   sleep 0.5
   wmctrl -lx | grep -F ' $old_class ' | awk '{print \$1}' | while read -r id; do
       xprop -f WM_CLASS 8s -set WM_CLASS "$new_class" -id "\$id" 2>/dev/null
   done
done) &
# Run application with firejail
firejail --noprofile --net=none --noblacklist=~/.local/share/Kingsoft \
   --noblacklist=~/.config/Kingsoft /usr/bin/$cmd "\$@"
# Clean up desktop files again
rm -f ~/Desktop/wps*.desktop ~/.local/share/applications/wps*.desktop
EOF

   $prun sudo chmod +x "/usr/local/bin/$cmd"
}

install_app() {
   check_dependencies
   
   local prun=$(get_prun_command)
   local deb_name=$(basename "${APP_CONFIG[url]}")
   local temp_dir=$(mktemp -d)
   
   log "Starting installation..."
   
   cd "$temp_dir" || error "Failed to create temporary directory"

   # Pre-configure keyboard settings to avoid prompts
   log "Setting up keyboard configuration..."
   $prun sudo bash -c 'echo "keyboard-configuration keyboard-configuration/layoutcode string us" | debconf-set-selections'
   $prun sudo bash -c 'echo "keyboard-configuration keyboard-configuration/variant string english" | debconf-set-selections'
   $prun sudo bash -c 'echo "keyboard-configuration keyboard-configuration/model string pc105" | debconf-set-selections'
   $prun sudo bash -c 'echo "keyboard-configuration keyboard-configuration/variantcode string" | debconf-set-selections'
   $prun sudo bash -c 'echo "keyboard-configuration keyboard-configuration/layout select English" | debconf-set-selections'
   $prun sudo bash -c 'echo "keyboard-configuration keyboard-configuration/optionscode string" | debconf-set-selections'
   $prun DEBIAN_FRONTEND=noninteractive sudo dpkg-reconfigure keyboard-configuration -f noninteractive

   # Install dependencies
   log "Installing dependencies..."
   $prun sudo DEBIAN_FRONTEND=noninteractive apt update || error "Failed to update package lists"
   $prun sudo DEBIAN_FRONTEND=noninteractive apt install -y ${APP_CONFIG[dependencies]} || error "Failed to install dependencies"

   # Install additional PDF support packages
   log "Installing PDF support packages..."
   $prun sudo apt install -y libwebp6 libtiff5 || {
       $prun wget "http://ftp.debian.org/debian/pool/main/libw/libwebp/libwebp6_0.6.1-2.1+deb11u2_arm64.deb"
       $prun wget "http://ftp.debian.org/debian/pool/main/t/tiff/libtiff5_4.2.0-1+deb11u5_arm64.deb"
       $prun sudo dpkg -i libwebp6*.deb libtiff5*.deb
   }

   # Fix empty XML file issue
   log "Setting up MIME types..."
   $prun sudo bash -c 'cat > /usr/share/mime/packages/custom-wps-office.xml << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
 <mime-type type="application/wps-office.wps">
   <comment>WPS Writer Document</comment>
   <glob pattern="*.wps"/>
 </mime-type>
 <mime-type type="application/wps-office.wpt">
   <comment>WPS Writer Template</comment>
   <glob pattern="*.wpt"/>
 </mime-type>
 <mime-type type="application/wps-office.dps">
   <comment>WPS Presentation</comment>
   <glob pattern="*.dps"/>
 </mime-type>
 <mime-type type="application/wps-office.dpt">
   <comment>WPS Presentation Template</comment>
   <glob pattern="*.dpt"/>
 </mime-type>
 <mime-type type="application/wps-office.et">
   <comment>WPS Spreadsheet</comment>
   <glob pattern="*.et"/>
 </mime-type>
 <mime-type type="application/wps-office.ett">
   <comment>WPS Spreadsheet Template</comment>
   <glob pattern="*.ett"/>
 </mime-type>
</mime-info>
EOF'

   # Download and install WPS Office
   log "Downloading WPS Office package..."
   $prun wget -O "$deb_name" "${APP_CONFIG[url]}" || error "Failed to download WPS Office package"

   log "Installing WPS Office..."
   $prun sudo dpkg -i "./$deb_name" || {
       log "Initial installation failed, fixing dependencies..."
       $prun sudo apt install -f -y
       # Make sure hexdump is available
       $prun sudo apt install -y bsdextrautils
       # Try to configure the package again
       $prun sudo dpkg --configure -a
       $prun sudo dpkg -i "./$deb_name" || error "Failed to install WPS Office"
   }

   # Create wrapper scripts
   log "Creating wrapper scripts..."
   create_wrapper "wps" "wps.wps" "wps-office2019-wpsmain"
   create_wrapper "wpspdf" "wpspdf.wps" "wps-office2019-pdfmain"
   create_wrapper "wpp" "wpp.wpp" "wps-office2019-wppmain"
   create_wrapper "et" "et.et" "wps-office2019-etmain"

   # Update icon cache and fix icon symlinks
   log "Updating icon cache..."
   $prun sudo find /usr/share/icons/hicolor -name "wps-office2019-kprometheus.png" -exec bash -c '
       sudo ln -sf "$1" "${1/\/mimetypes\//\/apps\/}"
       sudo ln -sf "$1" "${1/wps-office2019-kprometheus.png/wpsoffice.png}"
   ' _ {} \;
   
   $prun sudo update-icon-caches /usr/share/icons/*
   $prun sudo xdg-icon-resource forceupdate --mode system

   # Create desktop entries
   log "Creating desktop entries..."
   mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
   
   # Define app-specific configurations
   declare -A app_configs=(
       [wps]="WPS Writer;wps-office-wpsmain"
       [wpspdf]="WPS PDF;wps-office-pdfmain"
       [wpp]="WPS Presentation;wps-office-wppmain"
       [et]="WPS Spreadsheet;wps-office-etmain"
   )
   
   # Create individual application menu entries
   for app in "${!app_configs[@]}"; do
       IFS=';' read -r app_name app_icon <<< "${app_configs[$app]}"
       cat > "$APPLICATIONS_DIR/$app.desktop" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=$app_name
Exec=prun /usr/local/bin/$app
Icon=$app_icon
Terminal=false
Categories=${APP_CONFIG[category]}
Comment=${APP_CONFIG[description]}
MimeType=application/wps-office.wps;application/wps-office.wpt;application/wps-office.dps;application/wps-office.dpt;application/wps-office.et;application/wps-office.ett;
EOL
       chmod +x "$APPLICATIONS_DIR/$app.desktop"
   done

   # Create desktop launcher with specific icon
   cat > "$DESKTOP_DIR/wps-office.desktop" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=WPS Office
Exec=prun /usr/local/bin/wps
Icon=wps-office-wpsmain
Terminal=false
Categories=${APP_CONFIG[category]}
Comment=${APP_CONFIG[description]}
MimeType=application/wps-office.wps;application/wps-office.wpt;application/wps-office.dps;application/wps-office.dpt;application/wps-office.et;application/wps-office.ett;
EOL
   chmod +x "$DESKTOP_DIR/wps-office.desktop"

   # Remove cloud features
   log "Removing cloud features..."
   $prun sudo rm -f /opt/kingsoft/wps-office/office6/wpscloudsvr

   # Clean up downloaded .deb files
   log "Cleaning up downloaded packages..."
   $prun rm -rf 模板
   rm $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/phoenixbyrd/*.deb

   # Clean up
   log "Cleaning up..."
   cd "$HOME"
   rm -rf "$temp_dir"

   log "Installation completed successfully."
}

uninstall_app() {
   log "Starting uninstallation..."
   local prun=$(get_prun_command)

   # Remove WPS Office package
   $prun sudo apt remove -y wps-office || {
       log "Standard removal failed, trying forced removal..."
       $prun sudo dpkg --remove --force-all wps-office
   }

   # Remove wrapper scripts and desktop entries
   log "Removing wrapper scripts and desktop entries..."
   $prun sudo rm -f /usr/local/bin/{wps,wpspdf,wpp,et}
   rm -f "$DESKTOP_DIR/wps-office.desktop"
   rm -f "$APPLICATIONS_DIR"/{wps,wpspdf,wpp,et}.desktop

   # Clean up any leftover .deb files
   log "Cleaning up package files..."
   $prun rm -f ~/*.deb
   $prun rm -f ~/Downloads/*.deb

   # Clean up remaining files
   log "Performing additional cleanup..."
   $prun sudo apt autoremove -y
   $prun sudo apt clean

   log "Uninstallation completed."
}

# ============================================================================
# Main Script
# ============================================================================

main() {
   if [ "$1" = "--install" ] && { [ -z "${APP_CONFIG[url]}" ] || [ -z "${APP_CONFIG[name]}" ]; }; then
       error "URL and application name must be configured before installation"
   fi

   case "$1" in
       --install)
           install_app
           ;;
       --uninstall)
           uninstall_app
           ;;
       *)
           echo "Usage: $0 [--install|--uninstall]"
           echo "  --install   : Install WPS Office"
           echo "  --uninstall : Remove WPS Office"
           exit 1
           ;;
   esac
}

main "$@"