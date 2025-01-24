#!/data/data/com.termux/files/usr/bin/bash

# Configuration
declare -A APP_CONFIG=(
	[url]="https://github.com/TurboWarp/desktop/releases/download/v1.13.0-beta.4/TurboWarp-linux-arm64-1.13.0-beta.4.deb"
	[name]="TurboWarp"
	[icon]="turbowarp"
	[category]="Development"
	[dependencies]="libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libuuid1 libappindicator3-1 libsecret-1-0"
	[description]="TurboWarp is a Scratch mod that compiles projects to JavaScript to make them run really fast."
)

# Default paths
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$PREFIX/share/applications"

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
Exec=$prun GALLIUM_DRIVER=virpipe /opt/TurboWarp/turbowarp-desktop --no-sandbox
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
    
    # Download TurboWarp .deb package
    log "Downloading TurboWarp..."
    $prun wget "${APP_CONFIG[url]}"
    
    # Install the .deb package
    log "Installing TurboWarp..."
    $prun sudo dpkg -i TurboWarp-linux-arm64-1.13.0-beta.4.deb
    
    # Fix any missing dependencies
    log "Fixing dependencies..."
    $prun sudo apt --fix-broken install -y
    
    # Move TurboWarp to /opt for better organization
    log "Moving TurboWarp to /opt..."
    $prun sudo mkdir -p /opt/TurboWarp
    $prun sudo mv /usr/lib/turbowarp-desktop/* /opt/TurboWarp/
    $prun sudo rm -rf /usr/lib/turbowarp-desktop
    
    # Download TurboWarp icon
    log "Downloading TurboWarp icon..."
    $prun sudo wget -O /opt/TurboWarp/icon.png https://turbowarp.org/images/icon.png
    
    log "Cleaning up..."
    $prun rm TurboWarp-linux-arm64-1.13.0-beta.4.deb

    # Create desktop entries
    log "Creating desktop entries..."
    mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
    local desktop="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop "$desktop"
    cp "$desktop" "$APPLICATIONS_DIR"
    
    log "Installation complete"
    log "You can now launch TurboWarp from your desktop or applications menu."
}

# Uninstall application
uninstall() {
    log "Starting uninstallation..."
    local prun=$(get_prun)
    $prun sudo dpkg --remove turbowarp-desktop
    $prun sudo rm -rf /opt/TurboWarp
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
            echo "  --install   : Install TurboWarp"
            echo "  --uninstall : Remove TurboWarp"
            exit 1
            ;;
    esac
}

main "$@"