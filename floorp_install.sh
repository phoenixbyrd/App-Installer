#!/data/data/com.termux/files/usr/bin/bash

# Configuration
declare -A APP_CONFIG=(
	[url]="https://github.com/Floorp-Projects/Floorp/releases/download/v11.22.0/floorp-11.22.0.linux-aarch64.tar.bz2"
	[name]="Floorp"
	[icon]="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/opt/floorp/browser/chrome/icons/default/default128.png"
	[category]="Network"
	[dependencies]="libgtk-3-0 libdbus-glib-1-2 libxt6"
	[description]="Floorp is a privacy-focused web browser based on Firefox."
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
Exec=$prun /opt/floorp/floorp
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
    
    # Download and extract
    log "Downloading Floorp..."
    $prun wget "${APP_CONFIG[url]}"
    
    log "Creating directory..."
    $prun sudo mkdir -p /opt/floorp
    
    log "Extracting archive..."
    $prun sudo tar -xvjf floorp-11.22.0.linux-aarch64.tar.bz2 -C /opt/floorp --strip-components=1
    
    log "Setting execute permissions..."
    $prun sudo chmod +x /opt/floorp/floorp
    
    log "Cleaning up..."
    $prun rm floorp-11.22.0.linux-aarch64.tar.bz2

    # Create desktop entries
    log "Creating desktop entries..."
    mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
    local desktop="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop "$desktop"
    cp "$desktop" "$APPLICATIONS_DIR"
    
    log "Installation complete"
    log "You can now launch Floorp from your desktop or applications menu."
}

# Uninstall application
uninstall() {
    log "Starting uninstallation..."
    local prun=$(get_prun)
    $prun sudo rm -rf /opt/floorp
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
            echo "  --install   : Install Floorp"
            echo "  --uninstall : Remove Floorp"
            exit 1
            ;;
    esac
}

main "$@"