#!/bin/bash

varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

# Get the absolute path for the script's directory
script_dir=$(realpath "$(dirname "$0")")

# Absolute paths for required files and directories
installed_rootfs_dir="/usr/var/lib/proot-distro/installed-rootfs/debian/home"
freetube_desktop="$HOME/../usr/share/applications/freetube.desktop"
tor_desktop="$HOME/../usr/share/applications/tor.desktop"
webcord_desktop="$HOME/../usr/share/applications/webcord.desktop"
vivaldi_desktop="$HOME/../usr/share/applications/vivaldi.desktop"
brave_desktop="$HOME/../usr/share/applications/brave.desktop"
obsidian_desktop="$HOME/../usr/share/applications/obsidian.desktop"
libreoffice_desktop="$HOME/../usr/share/applications/libreoffice-base.desktop"
code_desktop="$HOME/../usr/share/applications/code.desktop"
vlc_desktop="$HOME/../usr/share/applications/vlc.desktop"
notion_desktop="$HOME/../usr/share/applications/notion.desktop"
pycharm_desktop="$HOME/../usr/share/applications/pycharm.desktop"
remarkable_desktop="$HOME/../usr/share/applications/remarkable.desktop"
shatteredpd_desktop="$HOME/../usr/share/applications/shatteredpd.desktop"
el_desktop="$HOME/../usr/share/applications/el.desktop"
librewolf_desktop="$HOME/../usr/share/applications/librewolf.desktop"
unciv_desktop="$HOME/../usr/share/applications/unciv.desktop"
diablo_desktop="$HOME/../usr/share/applications/diablo.desktop"
element_desktop="$HOME/../usr/share/applications/element.desktop"
prism_desktop="$HOME/../usr/share/applications/prism.desktop"
wine_desktop="$HOME/../usr/share/applications/wine32.desktop"
runelite_desktop="$HOME/../usr/share/applications/runelite.desktop"

check_freetube_installed() {
    if [ -e "$freetube_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_tor_browser_installed() {
    if [ -e "$tor_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_webcord_installed() {
    if [ -e "$webcord_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_vivaldi_installed() {
    if [ -e "$vivaldi_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_brave_installed() {
    if [ -e "$brave_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_obsidian_installed() {
    if [ -e "$obsidian_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_libreoffice_installed() {
    if [ -e "$libreoffice_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_code_installed() {
    if [ -e "$code_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_vlc_installed() {
    if [ -e "$vlc_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_notion_installed() {
    if [ -e "$notion_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_pycharm_installed() {
    if [ -e "$pycharm_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_remarkable_installed() {
    if [ -e "$remarkable_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_shatteredpd_installed() {
    if [ -e "$shatteredpd_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}


check_el_installed() {
    if [ -e "$el_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_librewolf_installed() {
    if [ -e "$librewolf_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_unciv_installed() {
    if [ -e "$unciv_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_diablo_installed() {
    if [ -e "$diablo_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_element_installed() {
    if [ -e "$element_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_prism_installed() {
    if [ -e "$prism_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_wine_installed() {
    if [ -e "$wine_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

check_runelite_installed() {
    if [ -e "$runelite_desktop" ]; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}


install_freetube() {
    "$script_dir/install_freetube.sh"
    zenity --info --title="Installation Complete" --text="FreeTube has been installed successfully."
}

install_tor_browser() {
    "$script_dir/install_tor_browser.sh"
    zenity --info --title="Installation Complete" --text="Tor Browser has been installed successfully."
}

install_webcord() {
    "$script_dir/install_webcord.sh"
    zenity --info --title="Installation Complete" --text="Webcord has been installed successfully."
}

install_vivaldi() {
    "$script_dir/install_vivaldi.sh"
    zenity --info --title="Installation Complete" --text="Vivaldi has been installed successfully."
}

install_brave() {
    "$script_dir/install_brave.sh"
    zenity --info --title="Installation Complete" --text="Brave has been installed successfully."
}

install_obsidian() {
    "$script_dir/install_obsidian.sh"
    zenity --info --title="Installation Complete" --text="Obsidian has been installed successfully."
}

install_libreoffice() {
    "$script_dir/install_libreoffice.sh"
    zenity --info --title="Installation Complete" --text="Libreoffice has been installed successfully."
}

install_code() {
    "$script_dir/install_vscode.sh"
    zenity --info --title="Installation Complete" --text="Visual Studio has been installed successfully."
}

install_vlc() {
    "$script_dir/install_vlc.sh"
    zenity --info --title="Installation Complete" --text="VLC has been installed successfully."
}

install_notion() {
    "$script_dir/install_notion.sh"
    zenity --info --title="Installation Complete" --text="Notion has been installed successfully."
}

install_pycharm() {
    "$script_dir/install_pycharm.sh"
    zenity --info --title="Installation Complete" --text="PyCharm has been installed successfully."
}

install_remarkable() {
    "$script_dir/install_remarkable.sh"
    zenity --info --title="Installation Complete" --text="Remarkable has been installed successfully."
}

install_shatteredpd() {
    "$script_dir/install_shatteredpd.sh"
    zenity --info --title="Installation Complete" --text="Shattered Pixel Dungeon has been installed successfully."
}

install_el() {
    "$script_dir/install_el.sh"
    zenity --info --title="Installation Complete" --text="Eternal Lands has been installed successfully."
}

install_librewolf() {
    "$script_dir/install_librewolf.sh"
    zenity --info --title="Installation Complete" --text="Librewolf has been installed successfully."
}

install_unciv() {
    "$script_dir/install_unciv.sh"
    zenity --info --title="Installation Complete" --text="Unciv has been installed successfully."
}

install_diablo() {
    "$script_dir/install_diablo.sh"
    zenity --info --title="Installation Complete" --text="DevilutionX has been installed successfully."
}

install_element() {
    "$script_dir/install_element.sh"
    zenity --info --title="Installation Complete" --text="Element has been installed successfully."
}

install_prism() {
    "$script_dir/install_prismlauncher.sh"
    zenity --info --title="Installation Complete" --text="Prism Launcher has been installed successfully."
}

install_wine() {
    "$script_dir/install_wine.sh"
    zenity --info --title="Installation Complete" --text="Box86, Box64 and Wine has been installed successfully."
}


install_runelite() {
    "$script_dir/install_runelite.sh"
    zenity --info --title="Installation Complete" --text="RuneLite has been installed successfully."
}

remove_freetube() {
    if [ -e "$freetube_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S apt remove freetube
        rm "$HOME/Desktop/freetube.desktop"
        rm "$freetube_desktop"
        zenity --info --title="Removal Complete" --text="FreeTube has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="FreeTube is not installed."
    fi
}

remove_tor_browser() {
    if [ -e "$tor_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf tor-browser
        rm "$HOME/Desktop/tor.desktop"
        rm "$tor_desktop"
        zenity --info --title="Removal Complete" --text="Tor Browser has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Tor Browser is not installed."
    fi
}

remove_webcord() {
    if [ -e "$webcord_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S apt remove webcord
        rm "$HOME/Desktop/webcord.desktop"
        rm "$webcord_desktop"
        zenity --info --title="Removal Complete" --text="Webcord has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Webcord is not installed."
    fi
}

remove_vivaldi() {
    if [ -e "$vivaldi_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt-mark unhold vivaldi-stable
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove vivaldi-stable -y
        rm "$HOME/Desktop/vivaldi.desktop"
        rm "$vivaldi_desktop"
        zenity --info --title="Removal Complete" --text="Vivaldi has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Vivaldi is not installed."
    fi
}

remove_brave() {
    if [ -e "$brave_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo -S apt remove brave-browser -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm /etc/apt/sources.list.d/brave-browser-release.list
        rm "$HOME/Desktop/brave.desktop"
        rm "$brave_desktop"
        zenity --info --title="Removal Complete" --text="Brave has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Brave is not installed."
    fi
}

remove_obsidian() {
    if [ -e "$obsidian_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf Obsidian
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf Obsidian\ Vault
        rm "$HOME/Desktop/obsidian.desktop"
        rm "$obsidian_desktop"
        zenity --info --title="Removal Complete" --text="Obsidian has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Obsidian is not installed."
    fi
}

remove_libreoffice() {
    if [ -e "$libreoffice_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove libreoffice -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        rm "$HOME/../usr/share/applications/libreoffice*"
        rm "$libreoffice_desktop"
        zenity --info --title="Removal Complete" --text="Libreoffice has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Libreoffice is not installed."
    fi
}

remove_code() {
    if [ -e "$code_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove code -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        rm "$HOME/../usr/share/applications/code.desktop"
        rm "$HOME/Desktop/code.desktop"
        rm "$code_desktop"
        zenity --info --title="Removal Complete" --text="VS Code has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="VS Code is not installed."
    fi
}

remove_vlc() {
    if [ -e "$vlc_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove vlc -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        rm "$vlc_desktop"
        zenity --info --title="Removal Complete" --text="VLC has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="VLC is not installed."
    fi
}

remove_notion() {
    if [ -e "$notion_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf notion
        rm "$HOME/Desktop/notion.desktop"
        rm "$notion_desktop"
        zenity --info --title="Removal Complete" --text="Notion has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Notion is not installed."
    fi
}

remove_pycharm() {
    if [ -e "$pycharm_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf /opt/pycharm-community
        rm "$HOME/Desktop/pycharm.desktop"
        rm "$pycharm_desktop"
        zenity --info --title="Removal Complete" --text="PyCharm has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="PyCharm is not installed."
    fi
}

remove_remarkable() {
    if [ -e "$remarkable_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove remarkable -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        rm "$HOME/Desktop/remarkable.desktop"
        rm "$remarkable_desktop"
        zenity --info --title="Removal Complete" --text="Remarkable has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Remarkable is not installed."
    fi
}

remove_shatteredpd() {
    if [ -e "$shatteredpd_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf /opt/ShatteredPD
        rm "$HOME/Desktop/shatteredpd.desktop"
        rm "$shatteredpd_desktop"
        zenity --info --title="Removal Complete" --text="Shattered Pixel Dungeon has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Shattered Pixel Dungeon is not installed."
    fi
}

remove_el() {
    if [ -e "$el_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf eternallands
        rm "$HOME/Desktop/el.desktop"
        rm "$el_desktop"
        zenity --info --title="Removal Complete" --text="Eternal Lands has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Eternal Lands is not installed."
    fi
}

remove_librewolf() {
    if [ -e "$librewolf_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf /opt/librewolf
        rm "$HOME/Desktop/librewolf.desktop"
        rm "$librewolf_desktop"
        zenity --info --title="Removal Complete" --text="ibrewolf has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Librewolf is not installed."
    fi
}

remove_unciv() {
    if [ -e "$unciv_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm /usr/games/Unciv.jar
        rm "$HOME/Desktop/unciv.desktop"
        rm "$unciv_desktop"
        zenity --info --title="Removal Complete" --text="Unciv has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Unciv is not installed."
    fi
}

remove_diablo() {
    if [ -e "$diablo_desktop" ]; then
        rm -rf ../usr/var/lib/proot-distro/installed-rootfs/debian/opt/devilutionx
        rm "$HOME/Desktop/diablo.desktop"
        rm "$diablo_desktop"
        zenity --info --title="Removal Complete" --text="DevilutionX has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="DevilutionX is not installed."
    fi
}

remove_element() {
    if [ -e "$element_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove element-desktop -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        rm "$HOME/Desktop/element.desktop"
        rm "$element_desktop"
        zenity --info --title="Removal Complete" --text="Element has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Element is not installed."
    fi
}

remove_prism() {
    if [ -e "$prism_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove prismlauncher -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        rm "$HOME/Desktop/prism.desktop"
        rm "$prism_desktop"
        zenity --info --title="Removal Complete" --text="Prism Launcher has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Prism Launcher is not installed."
    fi
}

remove_wine() {
    if [ -e "$wine_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt remove box64-android box32-android -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 sudo apt autoremove -y
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf wine*
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf .wine*
        rm "$HOME/Desktop/wine32.desktop"
        rm "$HOME/Desktop/wine64.desktop"
        rm "$HOME/../usr/share/applications/wine32.desktop"
        rm "$wine_desktop"
        zenity --info --title="Removal Complete" --text="Box86, Box64 and Wine have been removed successfully."
    else
        zenity --error --title="Removal Error" --text="Box86, Box64 and Wine are not installed."
    fi
}

remove_runelite() {
    if [ -e "$runelite_desktop" ]; then
        proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 rm -rf /opt/RuneLite
        rm "$HOME/Desktop/runelite.desktop"
        rm "$runelite_desktop"
        zenity --info --title="Removal Complete" --text="RuneLite has been removed successfully."
    else
        zenity --error --title="Removal Error" --text="RuneLite is not installed."
    fi
}

while true; do
    # Determine the installation status of each app
    freetube_status=$(check_freetube_installed)
    tor_browser_status=$(check_tor_browser_installed)
    webcord_status=$(check_webcord_installed)
    vivaldi_status=$(check_vivaldi_installed)
    brave_status=$(check_brave_installed)
    obsidian_status=$(check_obsidian_installed)
    libreoffice_status=$(check_libreoffice_installed)
    code_status=$(check_code_installed)
    vlc_status=$(check_vlc_installed)
    notion_status=$(check_notion_installed)
    pycharm_status=$(check_pycharm_installed)
    remarkable_status=$(check_remarkable_installed)
    shatteredpd_status=$(check_shatteredpd_installed)
    el_status=$(check_el_installed)
    librewolf_status=$(check_librewolf_installed)
    unciv_status=$(check_unciv_installed)
    diablo_status=$(check_diablo_installed)
    element_status=$(check_element_installed)
    prism_status=$(check_prism_installed)
    wine_status=$(check_wine_installed)
    runelite_status=$(check_runelite_installed)

    # Define the actions based on the installation status
    if [ "$freetube_status" == "Installed" ]; then
        freetube_action="Remove FreeTube (Status: Installed)"
        freetube_description="A privacy-focused YouTube client"
    else
        freetube_action="Install FreeTube (Status: Not Installed)"
        freetube_description="A privacy-focused YouTube client"
    fi

    if [ "$tor_browser_status" == "Installed" ]; then
        tor_browser_action="Remove Tor Browser (Status: Installed)"
        tor_browser_description="A web browser for anonymous browsing"
    else
        tor_browser_action="Install Tor Browser (Status: Not Installed)"
        tor_browser_description="A web browser for anonymous browsing"
    fi

    if [ "$webcord_status" == "Installed" ]; then
        webcord_action="Remove Webcord (Status: Installed)"
        webcord_description="A Discord web client"
    else
        webcord_action="Install Webcord (Status: Not Installed)"
        webcord_description="A Discord web client"
    fi

    if [ "$vivaldi_status" == "Installed" ]; then
        vivaldi_action="Remove Vivaldi (Status: Installed)"
        vivaldi_description="A freeware, cross-platform web browser"
    else
        vivaldi_action="Install Vivaldi (Status: Not Installed)"
        vivaldi_description="A freeware, cross-platform web browser"
    fi

    if [ "$brave_status" == "Installed" ]; then
        brave_action="Remove Brave (Status: Installed)"
        brave_description="A privacy-focused web browser"
    else
        brave_action="Install Brave (Status: Not Installed)"
        brave_description="A privacy-focused web browser"
    fi

    if [ "$obsidian_status" == "Installed" ]; then
        obsidian_action="Remove Obsidian (Status: Installed)"
        obsidian_description="A private and flexible note‑taking app"
    else
        obsidian_action="Install Obsidian (Status: Not Installed)"
        obsidian_description="A private and flexible note‑taking app"
    fi

    if [ "$libreoffice_status" == "Installed" ]; then
        libreoffice_action="Remove Libreoffice (Status: Installed)"
        libreoffice_description="A free and open-source office productivity software suite"
    else
        libreoffice_action="Install Libreoffice (Status: Not Installed)"
        libreoffice_description="A free and open-source office productivity software suite"
    fi

    if [ "$code_status" == "Installed" ]; then
        code_action="Remove Visual Studio Code (Status: Installed)"
        code_description="Code Editing. Redefined."
    else
        code_action="Install Visual Studio Code (Status: Not Installed)"
        code_description="Code Editing. Redefined."
    fi

    if [ "$vlc_status" == "Installed" ]; then
        vlc_action="Remove VLC (Status: Installed)"
        vlc_description="A free and open source cross-platform multimedia player "
    else
        vlc_action="Install VLC (Status: Not Installed)"
        vlc_description="A free and open source cross-platform multimedia player "
    fi

    if [ "$notion_status" == "Installed" ]; then
        notion_action="Remove Notion (Status: Installed)"
        notion_description="A freemium productivity and note-taking web application"
    else
        notion_action="Install Notion (Status: Not Installed)"
        notion_description="A freemium productivity and note-taking web application"
    fi

    if [ "$pycharm_status" == "Installed" ]; then
        pycharm_action="Remove PyCharm (Status: Installed)"
        pycharm_description="A Python IDE"
    else
        pycharm_action="Install PyCharm (Status: Not Installed)"
        pycharm_description="A Python IDE"
    fi
    
    if [ "$remarkable_status" == "Installed" ]; then
        remarkable_action="Remove Remarkable (Status: Installed)"
        remarkable_description="A Markdown Editor"
    else
        remarkable_action="Install Remarkable (Status: Not Installed)"
        remarkable_description="A Markdown Editor"
    fi

    if [ "$shatteredpd_status" == "Installed" ]; then
        shatteredpd_action="Remove Shattered Pixel Dungeon (Status: Installed)"
        shatteredpd_description="A traditional roguelike dungeon crawler RPG"
    else
        shatteredpd_action="Install Shattered Pixel Dungeon (Status: Not Installed)"
        shatteredpd_description="A traditional roguelike dungeon crawler RPG"
    fi

    if [ "$el_status" == "Installed" ]; then
        el_action="Remove Eternal Lands (Status: Installed)"
        el_description="A FREE 3D fantasy MMORPG "
    else
        el_action="Install Eternal Lands (Status: Not Installed)"
        el_description="A FREE 3D fantasy MMORPG "
    fi

    if [ "$librewolf_status" == "Installed" ]; then
        librewolf_action="Remove Librewolf (Status: Installed)"
        librewolf_description="A free and open-source web browser"
    else
        librewolf_action="Install Librewolf (Status: Not Installed)"
        librewolf_description="A free and open-source web browser"
    fi

    if [ "$unciv_status" == "Installed" ]; then
        unciv_action="Remove Unciv (Status: Installed)"
        unciv_description="Open-source remake of Civ V "
    else
        unciv_action="Install Unciv (Status: Not Installed)"
        unciv_description="Open-source remake of Civ V"
    fi

    if [ "$diablo_status" == "Installed" ]; then
        diablo_action="Remove DevilutionX (Status: Installed)"
        diablo_description="Diablo build for modern operating systems"
    else
        diablo_action="Install DevilutionX (Status: Not Installed)"
        diablo_description="Diablo build for modern operating systems"
    fi

    if [ "$element_status" == "Installed" ]; then
        element_action="Remove Element (Status: Installed)"
        element_description="A secure communications platform "
    else
        element_action="Install Element (Status: Not Installed)"
        element_description="A secure communications platform "
    fi

    if [ "$prism_status" == "Installed" ]; then
        prism_action="Remove Prism Launcher (Status: Installed)"
        prism_description="A free all-in-one modpack available on all versions of Minecraft "
    else
        prism_action="Install Prism Launcher (Status: Not Installed)"
        prism_description="A free all-in-one modpack available on all versions of Minecraft "
    fi

    if [ "$wine_status" == "Installed" ]; then
        wine_action="Remove Box86, Box64 and Wine (Status: Installed)"
        wine_description="lets you run x86_64 Linux and Windows programs"
    else
        wine_action="Install Box86, Box64 and Wine (Status: Not Installed)"
        wine_description="lets you run x86_64 Linux and Windows programs"
    fi

    if [ "$runelite_status" == "Installed" ]; then
        runelite_action="Remove RuneLite (Status: Installed)"
        runelite_description="Old School RuneScape Client"
    else
        runelite_action="Install RuneLite (Status: Not Installed)"
        runelite_description="Old School RuneScape Client"
    fi

    # Set the dark GTK theme
    export GTK_THEME=Adwaita:dark

# Display the selection dialog
choice=$(zenity --list --radiolist \
    --title="App Installer" \
    --text="Select an action:" \
    --column="Select" --column="Action" --column="Description" \
    FALSE "$freetube_action" "$freetube_description" \
    FALSE "$tor_browser_action" "$tor_browser_description" \
    FALSE "$webcord_action" "$webcord_description" \
    FALSE "$vivaldi_action" "$vivaldi_description" \
    FALSE "$brave_action" "$brave_description" \
    FALSE "$obsidian_action" "$obsidian_description" \
    FALSE "$libreoffice_action" "$libreoffice_description" \
    FALSE "$code_action" "$code_description" \
    FALSE "$vlc_action" "$vlc_description" \
    FALSE "$notion_action" "$notion_description" \
    FALSE "$pycharm_action" "$pycharm_description" \
    FALSE "$remarkable_action" "$remarkable_description" \
    FALSE "$shatteredpd_action" "$shatteredpd_description" \
    FALSE "$el_action" "$el_description" \
    FALSE "$librewolf_action" "$librewolf_description" \
    FALSE "$unciv_action" "$unciv_description" \
    FALSE "$diablo_action" "$diablo_description" \
    FALSE "$element_action" "$element_description" \
    FALSE "$prism_action" "$prism_description" \
    FALSE "$wine_action" "$wine_description" \
    FALSE "$runelite_action" "$runelite_description" \
    SEPARATOR \
    --width=875 --height=450)

    # Check if the user canceled the selection
    if [ -z "$choice" ]; then
        exit 0
    fi

    # Execute the selected action
    case $choice in
        "$freetube_action")
            if [ "$freetube_status" == "Installed" ]; then
                remove_freetube
            else
                install_freetube
            fi
            ;;
        "$tor_browser_action")
            if [ "$tor_browser_status" == "Installed" ]; then
                remove_tor_browser
            else
                install_tor_browser
            fi
            ;;
        "$webcord_action")
            if [ "$webcord_status" == "Installed" ]; then
                remove_webcord
            else
                install_webcord
            fi
            ;;
        "$vivaldi_action")
            if [ "$vivaldi_status" == "Installed" ]; then
                remove_vivaldi
            else
                install_vivaldi
            fi
            ;;
        "$brave_action")
            if [ "$brave_status" == "Installed" ]; then
                remove_brave
            else
                install_brave
            fi
            ;;
        "$obsidian_action")
            if [ "$obsidian_status" == "Installed" ]; then
                remove_obsidian
            else
                install_obsidian
            fi
            ;;    
        "$libreoffice_action")
            if [ "$libreoffice_status" == "Installed" ]; then
                remove_libreoffice
            else
                install_libreoffice
            fi
            ;;     
        "$code_action")
            if [ "$code_status" == "Installed" ]; then
                remove_code
            else
                install_code
            fi
            ;;     
        "$vlc_action")
            if [ "$vlc_status" == "Installed" ]; then
                remove_vlc
            else
                install_vlc
            fi
            ;;        
        "$notion_action")
            if [ "$notion_status" == "Installed" ]; then
                remove_notion
            else
                install_notion
            fi
            ;;   
        "$pycharm_action")
            if [ "$pycharm_status" == "Installed" ]; then
                remove_pycharm
            else
                install_pycharm
            fi
            ;;   
        "$remarkable_action")
            if [ "$remarkable_status" == "Installed" ]; then
                remove_remarkable
            else
                install_remarkable
            fi
            ;;   
        "$shatteredpd_action")
            if [ "$shatteredpd_status" == "Installed" ]; then
                remove_shatteredpd
            else
                install_shatteredpd
            fi
            ;;   
        "$el_action")
            if [ "$el_status" == "Installed" ]; then
                remove_el
            else
                install_el
            fi
            ;;   
            "$librewolf_action")
            if [ "$librewolf_status" == "Installed" ]; then
                remove_librewolf
            else
                install_librewolf
            fi
            ;;   
        "$unciv_action")
            if [ "$unciv_status" == "Installed" ]; then
                remove_unciv
            else
                install_unciv
            fi
            ;; 
        "$diablo_action")
            if [ "$diablo_status" == "Installed" ]; then
                remove_diablo
            else
                install_diablo
            fi
            ;;   
        "$element_action")
            if [ "$element_status" == "Installed" ]; then
                remove_element
            else
                install_element
            fi
            ;;   
        "$prism_action")
            if [ "$prism_status" == "Installed" ]; then
                remove_prism
            else
                install_prism
            fi
            ;;   
        "$wine_action")
            if [ "$wine_status" == "Installed" ]; then
                remove_wine
            else
                install_wine
            fi
            ;;   
        "$runelite_action")
            if [ "$runelite_status" == "Installed" ]; then
                remove_runelite
            else
                install_runelite
            fi
            ;;   
        *)
            zenity --error --title="Error" --text="Invalid choice."
            ;;
    esac
done
