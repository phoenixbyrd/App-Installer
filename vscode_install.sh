#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# Configuration Section - Edit these values as needed
# ============================================================================

# Application Details
declare -A APP_CONFIG=(
    [url]="https://packages.microsoft.com/repos/code/pool/main/c/code/code_1.96.4-1736994636_arm64.deb"
    [name]="code"
    [icon]="vscode"
    [category]="Development;"
    [dependencies]=""
    [extra_flags]="--no-sandbox" #--no-sandbox for electron apps
    [custom_binary]="/usr/share/code/code"
    [description]="VScode editor. Redefined with AI."
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
    local binary_name="$2"

    # Add extra flags if specified
    local exec_command="prun $binary_name"
    if [ -n "${APP_CONFIG[extra_flags]}" ]; then
        exec_command="prun $binary_name ${APP_CONFIG[extra_flags]}"
    fi

    cat > "$desktop_file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_CONFIG[name]}
Exec=$exec_command
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
    local deb_name=$(basename "${APP_CONFIG[url]}")
    local temp_dir=$(mktemp -d)
    
    log "Starting installation..."
    
    # Change to temporary directory
    cd "$temp_dir" || error "Failed to create temporary directory"

    # Install dependencies if specified
    if [ -n "${APP_CONFIG[dependencies]}" ]; then
        log "Installing dependencies..."
        $prun sudo apt update || error "Failed to update package lists"
        $prun sudo apt install -y ${APP_CONFIG[dependencies]} || error "Failed to install dependencies"
    fi

    # Download .deb package
    log "Downloading .deb package..."
    $prun wget -O "$deb_name" "${APP_CONFIG[url]}" || error "Failed to download .deb package"

    # Install the .deb package
    log "Installing .deb package..."
    $prun sudo apt install -y "./$deb_name" || {
        log "Fixing dependencies..."
        $prun sudo apt install -f -y
        $prun sudo apt install -y "./$deb_name" || error "Failed to install .deb package"
    }

    # Try to find the binary name (usually matches package name)
    local binary_name="${APP_CONFIG[custom_binary]}"
    
    # Create desktop entry
    log "Creating desktop entry..."
    mkdir -p "$DESKTOP_DIR" || error "Failed to create desktop directory"
    mkdir -p "$APPLICATIONS_DIR" || error "Failed to create applications directory"
    
    local desktop_file="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop_entry "$desktop_file" "$binary_name"

    # Copy to applications directory
    cp "$desktop_file" "$APPLICATIONS_DIR" || error "Failed to copy desktop entry to applications directory"

    # Clean up temporary directory
    log "Cleaning up..."
    cd "$HOME"
    rm -rf "$temp_dir"
    $prun rm "$deb_name"

    log "Installation completed successfully."
}

uninstall_app() {
    log "Starting uninstallation..."

    local prun=$(get_prun_command)

    # Try to get package name from dpkg
    local package_name
    package_name=$($prun dpkg -l | grep -i "${APP_CONFIG[name]}" | awk '{print $2}' | head -n 1)

    # If package name is found, try to remove it
    if [ -n "$package_name" ]; then
        log "Removing package $package_name..."
        $prun sudo apt remove -y "$package_name" || {
            log "Standard removal failed, trying forced removal..."
            $prun sudo dpkg --remove --force-all "$package_name" || log "Warning: Package removal failed, continuing with cleanup..."
        }
        $prun sudo apt autoremove -y
    else
        log "Warning: Package not found in dpkg database"
    fi

    # Remove desktop entries (do this regardless of package removal success)
    log "Removing desktop entries..."
    rm -f "$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    rm -f "$APPLICATIONS_DIR/${APP_CONFIG[name]}.desktop"

    # Additional cleanup
    log "Performing additional cleanup..."
    $prun sudo apt clean
    $prun sudo apt autoremove -y

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
            echo "  --install   : Install the .deb package"
            echo "  --uninstall : Remove the installed package"
            exit 1
            ;;
    esac
}

main "$@"
