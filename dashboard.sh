#!/usr/bin/env bash

# 1. Dependency Check
if ! command -v yad &> /dev/null; then
    echo "Error: 'yad' is not installed. Please install it using: sudo apt install yad"
    exit 1
fi

# 2. Setup Variables
THEME_FILE="$HOME/.cache/ricky_theme_pref"
[ ! -f "$THEME_FILE" ] && echo "Adwaita-dark" > "$THEME_FILE"
APP_TITLE="Rick's Dashboard"

#######################################
# Actions
#######################################

install_flatpaks() {
    THEME_FILE="$HOME/.cache/ricky_theme_pref"
    APP_TITLE="Rick's Dashboard"
    local STATE=${1:-TRUE}
    export GTK_THEME=$(cat "$THEME_FILE")

    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    local APPS=(
        "$STATE" "Mail Viewer"       "EML and MSG file viewer"           "io.github.alescdb.mailviewer"
        "$STATE" "Fred TV"           "Fast And Powerful IPTV App"        "dev.fredol.open-tv"
        "$STATE" "gThumb"             "Image Viewer"                      "org.gnome.gThumb"
        "$STATE" "ZapZap"             "WhatsApp Messenger"                "com.rtosta.zapzap"
        "$STATE" "Ente Photos"        "Safe home for your photos"         "io.ente.photos"
        "$STATE" "PDF Arranger"       "Merge, shuffle, and crop PDFs"     "com.github.jeromerobert.pdfarranger"
        "$STATE" "Czkawka"            "Find duplicates, empty folders"    "com.github.qarmin.czkawka"
        "$STATE" "Musicfetch"         "Download songs and tag them"       "net.fhannenheim.musicfetch"
        "$STATE" "Shortwave"          "Listen to internet radio"           "de.haeckerfelix.Shortwave"
        "$STATE" "Brasero"            "Create and copy CDs and DVDs"      "org.gnome.Brasero"
        "$STATE" "Gapless"            "Play your music elegantly"         "com.github.neithern.g4music"
        "$STATE" "Impression"         "Create bootable drives"            "io.gitlab.adhami3310.Impression"
        "$STATE" "Haruna"             "Media player"                      "org.kde.haruna"
        "$STATE" "LibreOffice"        "Productivity suite"                "org.libreoffice.LibreOffice"
        "$STATE" "Extension Manager" "Install GNOME Extensions"           "com.mattjakeman.ExtensionManager"
        "$STATE" "Gramps"             "Genealogical research"             "org.gramps_project.Gramps"
    )

    choices=$(yad --title="$APP_TITLE" --list --checklist \
        --width=850 --height=550 --center \
        --column="Select" --column="App Name" --column="Description" --column="ID" \
        --hide-column=4 --button="Select All:2" --button="Unselect All:3" \
        --button="Install:0" --button="Cancel:1" "${APPS[@]}" --separator='|')

    local exit_status=$?
    if [[ $exit_status -eq 2 ]]; then install_flatpaks "TRUE"; return; fi
    if [[ $exit_status -eq 3 ]]; then install_flatpaks "FALSE"; return; fi
    [[ -z "$choices" || $exit_status -ne 0 ]] && return

    selected_ids=$(echo "$choices" | tr '|' '\n' | grep '\.')

    if [[ -n "$selected_ids" ]]; then
        total_apps=$(echo "$selected_ids" | wc -l)
        current_count=0
        (
        for id in $selected_ids; do
            current_count=$((current_count + 1))
            percentage=$(( current_count * 100 / total_apps ))
            echo "# Installing $id ($current_count of $total_apps)..."
            flatpak install --user -y flathub "$id" --noninteractive
            echo "$percentage"
        done
        ) | yad --title="$APP_TITLE" --progress --width=400 --center --auto-close --percentage=0
        yad --title="$APP_TITLE" --text="Installation Complete!" --button=OK --center
    fi
}

install_docker() {
    (
        echo "# Downloading Docker installation script..."
        curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        echo "30"
        echo "# Installing Docker (Authentication Required)..."
        pkexec sh /tmp/get-docker.sh
        echo "80"
        echo "# Configuring user groups..."
        sudo usermod -aG docker "$USER"
        echo "100"
    ) | yad --title="$APP_TITLE" --progress --width=400 --center --auto-close --percentage=0
    yad --title="$APP_TITLE" --text="Docker Installed!" --button=OK --center
}

setup_filebrowser() {
    local BASE_DIR="$HOME/Docker/Filebrowser"
    local CONF_DIR="$BASE_DIR/config"
    local YAML_FILE="$BASE_DIR/docker-compose.yaml"

    mkdir -p "$CONF_DIR"

    cat <<EOF > "$YAML_FILE"
services:
  filebrowser:
    image: hurlenko/filebrowser:latest
    container_name: filebrowser
    user: "$(id -u):$(id -g)"
    ports:
      - 3000:8080
    volumes:
      - "$HOME:/data"
      - "$CONF_DIR:/config"
    environment:
      - FB_BASEURL=/filebrowser
      - FB_NOAUTH=true
    restart: always
EOF

    # ONLY pkexec the docker command
    pkexec docker compose -f "$YAML_FILE" up -d

    if [ $? -eq 0 ]; then
        (
            echo "10"; echo "# Initializing..." ; sleep 1
            echo "60"; echo "# Starting Browser..." ; sleep 1
            echo "100"; echo "# Done!"
        ) | yad --title="$APP_TITLE" --progress --auto-close --width=300 --center
        
        # Now xdg-open runs as 'ricky' (the user), not root
        xdg-open "http://localhost:3000/filebrowser/files"
    else
        yad --error --text="Docker failed to start." --center
    fi
}

toggle_theme() {
    local CURRENT_THEME=$(cat "$THEME_FILE")
    if [ "$CURRENT_THEME" == "Adwaita-dark" ]; then
        echo "Adwaita" > "$THEME_FILE"
    else
        echo "Adwaita-dark" > "$THEME_FILE"
    fi
    pkill -USR1 -f "$APP_TITLE"
}

export -f install_flatpaks
export -f install_docker
export -f setup_filebrowser

#######################################
# Main Menu
#######################################
trap "pkill -f 'yad.*$APP_TITLE'; continue" USR1

while true; do
    export GTK_THEME=$(cat "$THEME_FILE")
    THEME_LABEL="🌙 Dark Mode"
    [[ "$GTK_THEME" == "Adwaita-dark" ]] && THEME_LABEL="☀️ Light Mode"

    yad --form --title="$APP_TITLE" \
        --width=350 --height=550 --center --scroll \
        --field="<b></b>":LBL "" \
        --field="🌐 Website":FBTN 'xdg-open "https://homepage.craft.me/rickos"' \
        --field="⬆️ Ubuntu - Update":FBTN "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c 'apt update && apt upgrade -y && yad --text=\"System Updated\" --button=OK --center'" \
        --field="🧲 Ubuntu - Fix Dock":FBTN 'bash -c "gsettings set org.gnome.shell.extensions.dash-to-dock dock-position \"BOTTOM\"; gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true; gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false"' \
        --field="📦 Ubuntu - Enable Flatpak Support":FBTN "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c 'apt install -y flatpak && flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && yad --text=\"Flatpak Ready\" --button=OK --center'" \
        --field="⭐ Universal Flatpak List":FBTN 'bash -c install_flatpaks' \
        --field="🐳 Universal Docker Setup":FBTN 'bash -c install_docker' \
        --field="📁 Docker File Browser":FBTN 'bash -c setup_filebrowser' \
        --button="$THEME_LABEL:10" \
        --button="❌ Close:1"

    ret=$?
    [[ $ret -eq 10 ]] && { toggle_theme; continue; }
    [[ $ret -eq 1 || $ret -eq 252 ]] && break
done