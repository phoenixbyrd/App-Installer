#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# Configuration Section - Edit these values as needed
# ============================================================================

# Application Details
declare -A APP_CONFIG=(
    [url]="https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/134.0.1-1/LibreWolf.aarch64.AppImage"
    [name]="librewolf"
    [icon]="librewolf"
    [category]="Network;"
    [dependencies]="libdbus-glib-1-2 zlib1g-dev"
    [extra_flags]="" #--no-sandbox for electron apps
    [custom_binary]=""
    [description]="A custom version of Firefox, focused on privacy, security and freedom."
)

# System Paths
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$PREFIX/share/applications"
INSTALL_DIR="/opt"  # Changed this to use the correct path inside proot

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
EOL

    chmod +x "$desktop_file" || error "Failed to make desktop entry executable"
}

# ============================================================================
# Installation Functions
# ============================================================================

install_app() {
    check_dependencies
    
    local prun=$(get_prun_command)
    local app_dir="${APP_CONFIG[name]}"  # Changed this to be relative
    local appimage_name=$(basename "${APP_CONFIG[url]}")
    local temp_dir=$(mktemp -d)
    
    log "Starting installation..."
    
    # Change to temporary directory
    cd "$temp_dir" || error "Failed to create temporary directory"

    # Install dependencies if specified
    if [ -n "${APP_CONFIG[dependencies]}" ]; then
        log "Installing dependencies..."
        $prun apt update || error "Failed to update package lists"
        $prun apt install -y ${APP_CONFIG[dependencies]} || error "Failed to install dependencies"
    fi

    # Download AppImage
    log "Downloading AppImage..."
    $prun wget -O "$appimage_name" "${APP_CONFIG[url]}" || error "Failed to download AppImage"

    # Make AppImage executable
    log "Making AppImage executable..."
    $prun chmod +x "$appimage_name" || error "Failed to make AppImage executable"

    # Extract AppImage
    log "Extracting AppImage..."
    $prun ./"$appimage_name" --appimage-extract || error "Failed to extract AppImage"

    # Rename and move to installation directory
    log "Moving to installation directory..."
    $prun mv squashfs-root "$app_dir" || error "Failed to rename squashfs-root directory"
    $prun mv "$app_dir" "/opt/" || error "Failed to move application directory"

    # Set binary path to AppRun
    local binary="/opt/${APP_CONFIG[name]}/${APP_CONFIG[name]}"

    # Create desktop entry
    log "Creating desktop entry..."
    mkdir -p "$DESKTOP_DIR" || error "Failed to create desktop directory"
    mkdir -p "$APPLICATIONS_DIR" || error "Failed to create applications directory"
    
    local desktop_file="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop_entry "$desktop_file" "$binary"

    # Copy to applications directory
    cp "$desktop_file" "$APPLICATIONS_DIR" || error "Failed to copy desktop entry to applications directory"

    # Clean up temporary directory and AppImage
    log "Cleaning up..."
    $prun rm "$appimage_name" || log "Warning: Failed to remove AppImage file"
    cd "$HOME"
    rm -rf "$temp_dir"

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
            echo "  --install   : Install the AppImage application"
            echo "  --uninstall : Remove the AppImage application"
            exit 1
            ;;
    esac
}

main "$@"