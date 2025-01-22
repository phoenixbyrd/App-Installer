#!/data/data/com.termux/files/usr/bin/bash

# Configuration
declare -A APP_CONFIG
APP_CONFIG[url]="https://github.com/diasurgical/devilutionX/releases/download/1.5.0/devilutionx-linux-aarch64.tar.xz"
APP_CONFIG[name]="devilutionx"
APP_CONFIG[icon]="Diablo"
APP_CONFIG[category]="Game"
APP_CONFIG[dependencies]="libsdl2-image-2.0-0 libsodium23"
APP_CONFIG[description]="DevilutionX is a source port of Diablo"

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
    echo "proot-distro login debian --user $user --shared-tmp -- env DISPLAY=:1.0"
}

# Create desktop entry file
create_desktop() {
    local file="$1"
    cat > "$file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=DevilutionX
Exec=prun /opt/devilutionx/devilutionx
Icon=Diablo
Terminal=false
Categories=Game
Comment=DevilutionX is a source port of Diablo
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
    log "Downloading DevilutionX..."
    $prun wget "${APP_CONFIG[url]}"
    
    log "Creating directory..."
    $prun mkdir -p devilutionx
    
    log "Extracting archive..."
    $prun tar -xvf devilutionx-linux-aarch64.tar.xz -C devilutionx
    
    log "Moving to /opt..."
    $prun sudo mv devilutionx /opt/
    
    log "Cleaning up..."
    $prun rm devilutionx-linux-aarch64.tar.xz

    # Create desktop entries
    log "Creating desktop entries..."
    mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
    local desktop="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop "$desktop"
    cp "$desktop" "$APPLICATIONS_DIR"
    
    log "Installation complete"
    log "NOTE: Please place your diabdat.mpq file in ~/.local/share/diasurgical/devilution/"
}

# Uninstall application
uninstall() {
    log "Starting uninstallation..."
    local prun=$(get_prun)
    $prun sudo rm -rf /opt/devilutionx
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
            echo "  --install   : Install DevilutionX"
            echo "  --uninstall : Remove DevilutionX"
            exit 1
            ;;
    esac
}

main "$@"