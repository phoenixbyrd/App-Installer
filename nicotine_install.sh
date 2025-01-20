#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# Configuration Section - Edit these values as needed
# ============================================================================

# Application Details
declare -A APP_CONFIG=(
    [repo_url]="deb https://ppa.launchpadcontent.net/nicotine-team/stable/ubuntu jammy main"
    [name]="nicotine"
    [icon]="nicotine-plus"
    [category]="Network"
    [dependencies]="python3-launchpadlib software-properties-common"
    [extra_flags]="" #--no-sandbox for electron apps
    [description]="A graphical client for the Soulseek peer-to-peer network"
)

# System Paths
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$PREFIX/share/applications"
PROOT_BASE="$PREFIX/var/lib/proot-distro/installed-rootfs/debian"

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

# Get the debian username by checking the home directory
get_debian_username() {
    basename "$(ls -d $PROOT_BASE/home/* | head -1)"
}

# Function to optionally prefix command with sudo
maybe_sudo() {
    if [ "${APP_CONFIG[use_sudo]}" = "1" ]; then
        echo "sudo $1"
    else
        echo "$1"
    fi
}

# Function to run commands in proot debian
run_proot_command() {
    local cmd="$1"
    # For installation commands, always use root
    proot-distro login debian -- bash -c "$cmd"
}

# Function to run app commands in proot debian
run_app_command() {
    local username=$(get_debian_username)
    local cmd="$1"
    # For running the application, use the user account
    proot-distro login debian --user $username --shared-tmp -- bash -c "$(maybe_sudo "$cmd")"
}

create_desktop_entry() {
    local desktop_file="$1"
    local username=$(get_debian_username)
    
    # Prepare the exec command with optional sudo
    local exec_cmd="${APP_CONFIG[name]} ${APP_CONFIG[extra_flags]}"
    if [ "${APP_CONFIG[use_sudo]}" = "1" ]; then
        exec_cmd="sudo $exec_cmd"
    fi
    
    cat > "$desktop_file" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_CONFIG[name]}
Exec=proot-distro login debian --user $username --shared-tmp -- env DISPLAY=:0 $exec_cmd
Icon=${APP_CONFIG[icon]}
Categories=${APP_CONFIG[category]}
Terminal=false
EOL

    chmod +x "$desktop_file"
}

# ============================================================================
# Installation Functions
# ============================================================================

check_proot_debian() {
    if [ ! -d "$PROOT_BASE" ]; then
        log "Installing Debian in proot..."
        proot-distro install debian || error "Failed to install Debian"
    fi
}

install_dependencies() {
    if [ -n "${APP_CONFIG[dependencies]}" ]; then
        log "Installing dependencies..."
        run_proot_command "apt update && apt install -y ${APP_CONFIG[dependencies]}" || error "Failed to install dependencies"
    fi
}

add_repository() {
    if [ -n "${APP_CONFIG[repo_url]}" ]; then
        log "Adding repository..."
        run_proot_command "apt update && apt install -y software-properties-common && \
                          add-apt-repository '${APP_CONFIG[repo_url]}' -y && \
                          apt update" || error "Failed to add repository"
    fi
}

install_app() {
    log "Starting installation..."
    
    # Ensure proot debian is installed
    check_proot_debian
    
    # Install dependencies
    install_dependencies
    
    # Add repository if specified
    add_repository
    
    # Install the application
    log "Installing application..."
    run_proot_command "apt install -y ${APP_CONFIG[name]}" || error "Failed to install application"
    
    # Create desktop entry
    log "Creating desktop entry..."
    mkdir -p "$DESKTOP_DIR"
    mkdir -p "$APPLICATIONS_DIR"
    
    local desktop_file="$DESKTOP_DIR/${APP_CONFIG[name]}.desktop"
    create_desktop_entry "$desktop_file"
    
    # Copy to applications directory
    cp "$desktop_file" "$APPLICATIONS_DIR"
    
    log "Installation completed successfully."
}

uninstall_app() {
    log "Starting uninstallation..."
    
    # Remove the application from proot
    log "Removing application..."
    run_proot_command "apt remove -y ${APP_CONFIG[name]}" || error "Failed to remove application"
    
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
    # Verify configuration
    if [ "$1" = "--install" ] && [ -z "${APP_CONFIG[name]}" ]; then
        error "Package name must be configured before installation"
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