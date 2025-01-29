#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# Configuration Section - Edit these values as needed
# ============================================================================

# Application Details
declare -A APP_CONFIG=(
    [name]="libreoffice"
    [icon]="libreoffice"
    [category]="Office;"
    [dependencies]="libreoffice"
    [description]="A powerful office suite."
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

create_desktop_entry() {
    local desktop_file="$1"
    local binary_path="$2"

    cat > "$desktop_file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_CONFIG[name]}
Exec=prun $binary_path
Icon=${APP_CONFIG[icon]}
Terminal=false
Categories=${APP_CONFIG[category]}
Comment=${APP_CONFIG[description]}
EOL

    chmod +x "$desktop_file" || error "Failed to make desktop entry executable"
}

# ============================================================================
# Installation Functions
# ============================================================================

install_app() {
    check_dependencies
    
    local prun=$(get_prun_command)
    
    log "Starting installation..."
    
    # Install LibreOffice via apt
    log "Installing LibreOffice..."
    $prun apt update || error "Failed to update package lists"
    $prun sudo apt install -y ${APP_CONFIG[dependencies]} || error "Failed to install LibreOffice"

    # Copy desktop entries from Debian proot to Termux applications directory
    log "Copying desktop entries..."
    $prun cp $PREFIX/var/lib/proot-distro/installed-rootfs/debian/usr/share/applications/libreoffice-* "$APPLICATIONS_DIR" || error "Failed to copy desktop entries"

    # Modify desktop entries to use proot-distro
    log "Modifying desktop entries..."
    for desktop_file in "$APPLICATIONS_DIR"/libreoffice-*; do
        sed -i "s|^Exec=\(.*\)$|Exec=proot-distro login debian --user $(basename $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/*) --shared-tmp -- env DISPLAY=:0 \1|" "$desktop_file" || error "Failed to modify desktop entry"
    done

    log "Installation completed successfully."
}

uninstall_app() {
    log "Starting uninstallation..."

    local prun=$(get_prun_command)

    # Remove desktop entries
    log "Removing desktop entries..."
    rm -f "$APPLICATIONS_DIR"/libreoffice-*

    # Uninstall LibreOffice
    log "Uninstalling LibreOffice..."
    $prun sudo apt remove -y ${APP_CONFIG[dependencies]} || error "Failed to uninstall LibreOffice"

    log "Uninstallation completed successfully."
}

# ============================================================================
# Main Script
# ============================================================================

main() {
    if [ "$1" = "--install" ] && { [ -z "${APP_CONFIG[name]}" ]; }; then
        error "Application name must be configured before installation"
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
            echo "  --install   : Install the application"
            echo "  --uninstall : Remove the application"
            exit 1
            ;;
    esac
}

main "$@"