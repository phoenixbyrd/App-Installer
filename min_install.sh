#!/data/data/com.termux/files/usr/bin/bash

# Configuration
declare -A APP_CONFIG=(
	[url]="https://github.com/minbrowser/min/releases/download/v1.33.1/min-1.33.1-arm64.deb"
	[name]="Min Browser"
	[icon]="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/opt/Min/resources/app/icons/icon256.png"
	[category]="Network"
	[dependencies]="libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libuuid1 libappindicator3-1 libsecret-1-0"
	[description]="Min is a fast, minimal browser that protects your privacy."
)

# Default paths
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$PREFIX/share/applications"
ICONS_DIR="/usr/share/icons/hicolor/512x512/apps"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling
error() {
    log "ERROR: $1" >&2
    exit 1
}

# Get proot-distro run command
get_prun() {
    local user=$(basename "$PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/"* 2>/dev/null)
    [[ -z "$user" ]] && error "Failed to detect debian proot username"
    echo "proot-distro login debian --user $user --shared-tmp -- env DISPLAY=:0"
}

# Create desktop entry file
create_desktop() {
    local file="$1"
    local prun=$(get_prun)
    cat > "$file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_CONFIG[name]}
Exec=$prun MESA_NO_ERROR=1 LIBGL_DRI3_DISABLE=1 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform /opt/Min/min --no-sandbox
Icon=${APP_CONFIG[icon]}
Terminal=false
Categories=${APP_CONFIG[category]}
Comment=${APP_CONFIG[description]}
EOL

    chmod +x "$file" || error "Failed to make desktop entry executable"
}

# Install application
install() {
    local prun=$(get_prun)
    cd "$HOME"
    
    # Install dependencies first
    log "Installing dependencies..."
    $prun sudo apt update
    $prun sudo apt install -y ${APP_CONFIG[dependencies]}
    
    # Download Min Browser .deb package
    log "Downloading Min Browser..."
    $prun wget "${APP_CONFIG[url]}"
    
    # Install the .deb package
    log "Installing Min Browser..."
    $prun sudo dpkg -i min-1.33.1-arm64.deb
    
    # Fix any missing dependencies
    log "Fixing dependencies..."
    $prun sudo apt --fix-broken install -y
    
    # Move Min Browser to /opt for better organization
    log "Moving Min Browser to /opt..."
    $prun sudo mkdir -p /opt/Min
    $prun sudo mv /usr/lib/min/* /opt/Min/
    $prun sudo rm -rf /usr/lib/min
    
    # Download Min Browser icon and place it in the standard icon directory
    log "Downloading Min Browser icon..."
    $prun sudo mkdir -p "$ICONS_DIR"
    $prun sudo wget -O "$ICONS_DIR/${APP_CONFIG[icon]}" https://raw.githubusercontent.com/minbrowser/min/master/icons/icon512.png
    
    log "Cleaning up..."
    $prun rm min-1.33.1-arm64.deb

    # Create desktop entries
    log "Creating desktop entries..."
    mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
    local desktop="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop "$desktop"
    cp "$desktop" "$APPLICATIONS_DIR"
    
    log "Installation complete"
    log "You can now launch Min Browser from your desktop or applications menu."
}

# Uninstall application
uninstall() {
    log "Starting uninstallation..."
    local prun=$(get_prun)
    $prun sudo dpkg --remove min
    $prun sudo rm -rf /opt/Min
    $prun sudo rm -f "$ICONS_DIR/${APP_CONFIG[icon]}"
    rm -f "$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    rm -f "$APPLICATIONS_DIR/${APP_CONFIG[name]}.desktop"
    log "Uninstallation complete"
}

# Main
main() {
    case "$1" in
        --install)   install ;;
        --uninstall) uninstall ;;
        *)
            echo "Usage: $0 [--install|--uninstall]"
            echo "  --install   : Install Min Browser"
            echo "  --uninstall : Remove Min Browser"
            exit 1
            ;;
    esac
}

main "$@"