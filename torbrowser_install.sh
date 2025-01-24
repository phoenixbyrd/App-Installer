#!/data/data/com.termux/files/usr/bin/bash

# Configuration
declare -A APP_CONFIG=(
	[version]="13.0.9"  # Update this if a newer version is available
	[name]="Tor Browser"
	[icon]="tor-browser.png"
	[category]="Network"
	[dependencies]="libgtk-3-0 libdbus-glib-1-2 libxt6 libx11-xcb1 libxcb-shm0 libxcb-xfixes0 libxcb-randr0 libxcb-shape0 libxcomposite1 libxdamage1 libxfixes3 libxrender1 libxrandr2 libxss1 libxtst6 libatk1.0-0 libcairo2 libgdk-pixbuf2.0-0 libpango-1.0-0 libpangocairo-1.0-0 libasound2 libatk-bridge2.0-0 libglib2.0-0 libnspr4 libnss3 libpulse0"
	[description]="Tor Browser is a privacy-focused web browser that routes traffic through the Tor network."
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
Exec=$prun /opt/tor-browser/Browser/start-tor-browser
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
    
    # Download Tor Browser tarball from SourceForge
    log "Downloading Tor Browser..."
    $prun wget "https://sourceforge.net/projects/tor-browser-ports/files/${APP_CONFIG[version]}/tor-browser-linux-arm64-${APP_CONFIG[version]}.tar.xz"
    
    # Extract Tor Browser
    log "Extracting Tor Browser..."
    $prun sudo mkdir -p /opt/tor-browser
    $prun sudo tar -xvf "tor-browser-linux-arm64-${APP_CONFIG[version]}.tar.xz" -C /opt/tor-browser --strip-components=1
    
    # Download Tor Browser icon and place it in the standard icon directory
    log "Downloading Tor Browser icon..."
    $prun sudo mkdir -p "$ICONS_DIR"
    $prun sudo wget -O "$ICONS_DIR/${APP_CONFIG[icon]}" https://raw.githubusercontent.com/torproject/torbrowser-desktop/main/branding/default256.png
    
    log "Cleaning up..."
    $prun rm "tor-browser-linux-arm64-${APP_CONFIG[version]}.tar.xz"

    # Create desktop entries
    log "Creating desktop entries..."
    mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
    local desktop="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop "$desktop"
    cp "$desktop" "$APPLICATIONS_DIR"
    
    log "Installation complete"
    log "You can now launch Tor Browser from your desktop or applications menu."
}

# Uninstall application
uninstall() {
    log "Starting uninstallation..."
    local prun=$(get_prun)
    $prun sudo rm -rf /opt/tor-browser
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
            echo "  --install   : Install Tor Browser"
            echo "  --uninstall : Remove Tor Browser"
            exit 1
            ;;
    esac
}

main "$@"