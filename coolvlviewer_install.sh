#!/data/data/com.termux/files/usr/bin/bash

# Configuration
declare -A APP_CONFIG=(
	[url]="http://sldev.free.fr/binaries/CoolVLViewer-arm64-1.32.2.35.tar.bz2"
	[name]="CoolVLViewer"
	[icon]="/opt/coolvlviewer/secondlife_icon.png"
	[category]="Game;"
	[dependencies]="libgl1 libglu1-mesa libx11-6 libxext6 libxrender1 libssl3"
	[description]="CoolVLViewer is a lightweight and feature-rich Second Life viewer."
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
Exec=$prun MESA_NO_ERROR=1 LIBGL_DRI3_DISABLE=1 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform /opt/coolvlviewer/cool_vl_viewer
Icon=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/opt/coolvlviewer/secondlife_icon.png
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
    
    # Download and extract CoolVLViewer
    log "Downloading CoolVLViewer..."
    $prun wget "${APP_CONFIG[url]}"
    
    log "Creating directory..."
    $prun sudo mkdir -p /opt/coolvlviewer
    
    log "Extracting archive..."
    $prun sudo tar -xvjf CoolVLViewer-arm64-1.32.2.31.tar.bz2 -C /opt/coolvlviewer --strip-components=1
    
    log "Setting execute permissions..."
    $prun sudo chmod +x /opt/coolvlviewer/cool_vl_viewer
    
    # Download Second Life icon (PNG format)
    log "Downloading Second Life icon..."
    $prun sudo wget -O /opt/coolvlviewer/secondlife_icon.png https://secondlife.com/layout/img/backgrounds/DLbackground.png
    
    log "Cleaning up..."
    $prun rm CoolVLViewer-arm64-1.32.2.31.tar.bz2

    # Create desktop entries
    log "Creating desktop entries..."
    mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"
    local desktop="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop "$desktop"
    cp "$desktop" "$APPLICATIONS_DIR"
    
    log "Installation complete"
    log "You can now launch CoolVLViewer from your desktop or applications menu."
}

# Uninstall application
uninstall() {
    log "Starting uninstallation..."
    local prun=$(get_prun)
    $prun sudo rm -rf /opt/coolvlviewer
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
            echo "  --install   : Install CoolVLViewer"
            echo "  --uninstall : Remove CoolVLViewer"
            exit 1
            ;;
    esac
}

main "$@"
