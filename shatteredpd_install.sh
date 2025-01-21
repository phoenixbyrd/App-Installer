#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# Configuration Section - Edit these values as needed
# ============================================================================

# Application Details
declare -A APP_CONFIG=(
    [url]="https://github.com/00-Evan/shattered-pixel-dungeon/releases/download/v2.1.4/ShatteredPD-v2.1.4-Java.jar"
    [name]="shatteredpd"
    [icon]="com.shatteredpixel.shatteredpixeldungeon"
    [category]="Games;"
    [dependencies]="openjdk-17-jre libopenal1 zlib1g-dev"
    [extra_flags]=""
    [custom_binary]="java -jar /opt/shatteredpd/ShatteredPD.jar"
    [description]="A traditional roguelike dungeon crawler RPG"
)

# System Paths
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$PREFIX/share/applications"
INSTALL_DIR="/opt"

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
    echo "proot-distro login debian --user $username --shared-tmp -- env DISPLAY=:1.0"
}

create_desktop_entry() {
    local desktop_file="$1"
    local binary_path="$2"
    local final_binary="${APP_CONFIG[custom_binary]:-$binary_path}"

    cat > "$desktop_file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_CONFIG[name]}
Exec=prun $final_binary ${APP_CONFIG[extra_flags]}
Icon=${APP_CONFIG[icon]}
Terminal=false
Categories=${APP_CONFIG[category]}
Comment=${APP_CONFIG[description]}
StartupNotify=true
EOL

    chmod +x "$desktop_file" || error "Failed to make desktop entry executable"
}

# ============================================================================
# Installation Functions
# ============================================================================

install_app() {
    check_dependencies
    
    local prun=$(get_prun_command)
    local app_dir="${APP_CONFIG[name]}"
    local downloaded_file=$(basename "${APP_CONFIG[url]}")
    
    log "Starting installation..."

    # Install dependencies if specified
    if [ -n "${APP_CONFIG[dependencies]}" ]; then
        log "Installing dependencies..."
        $prun apt update || error "Failed to update package lists"
        $prun apt install -y ${APP_CONFIG[dependencies]} || error "Failed to install dependencies"
        $prun apt -f install || error "Failed to fix dependencies"
    fi

    # Create application directory
    log "Creating application directory..."
    $prun mkdir -p "/opt/$app_dir" || error "Failed to create application directory"

    # Download file
    log "Downloading application..."
    $prun wget -O "/opt/$app_dir/$downloaded_file" "${APP_CONFIG[url]}" || error "Failed to download application"

    # Set permissions if needed
    log "Setting permissions..."
    $prun chmod +x "/opt/$app_dir/$downloaded_file" || log "Warning: Failed to set executable permissions"
    $prun mv /opt/$app_dir/$downloaded_file /opt/$app_dir/ShatteredPD.jar 
    # Create desktop entry
    log "Creating desktop entry..."
    mkdir -p "$DESKTOP_DIR" || error "Failed to create desktop directory"
    mkdir -p "$APPLICATIONS_DIR" || error "Failed to create applications directory"
    
    local desktop_file="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop_entry "$desktop_file" "/opt/$app_dir/$downloaded_file"

    # Copy to applications directory
    cp "$desktop_file" "$APPLICATIONS_DIR" || error "Failed to copy desktop entry to applications directory"

    log "Installation completed successfully."
}

uninstall_app() {
    log "Starting uninstallation..."

    local prun=$(get_prun_command)
    local app_dir="/opt/${APP_CONFIG[name]}"

    # Remove application directory
    if $prun test -d "$app_dir"; then
        log "Removing application directory..."
        $prun rm -rf "$app_dir" || error "Failed to remove application directory"
    fi

    # Remove desktop entries
    log "Removing desktop entries..."
    rm -f "$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    rm -f "$APPLICATIONS_DIR/${APP_CONFIG[name]}.desktop"

    log "Uninstallation completed successfully."
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
            echo "  --install   : Install the downloaded application"
            echo "  --uninstall : Remove the application"
            exit 1
            ;;
    esac
}

main "$@"