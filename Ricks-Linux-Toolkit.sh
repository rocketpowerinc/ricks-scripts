#!/usr/bin/env bash

# File to store the current theme preference
THEME_FILE="/tmp/ricky_theme_pref"
[ ! -f "$THEME_FILE" ] && echo "Adwaita-dark" > "$THEME_FILE"

APP_TITLE="Rick's Dashboard"

# Export variables and functions for sub-shells
export THEME_FILE APP_TITLE

#######################################
# Actions
#######################################

toggle_theme() {
    CURRENT_THEME=$(cat "$THEME_FILE")
    if [ "$CURRENT_THEME" == "Adwaita-dark" ]; then
        echo "Adwaita" > "$THEME_FILE"
    else
        echo "Adwaita-dark" > "$THEME_FILE"
    fi
    pkill -USR1 -f "$APP_TITLE"
}

install_flatpaks() {
    STATE=${1:-TRUE}
    export GTK_THEME=$(cat "$THEME_FILE")

    APPS=(
        "$STATE" "Mail Viewer"       "EML and MSG file viewer"           "io.github.alescdb.mailviewer"
        "$STATE" "Fred TV"           "Fast And Powerful IPTV App"        "dev.fredol.open-tv"
        "$STATE" "gThumb"            "Image Viewer"                      "org.gnome.gThumb"
        "$STATE" "ZapZap"            "WhatsApp Messenger"                "com.rtosta.zapzap"
        "$STATE" "Ente Photos"       "Safe home for your photos"         "io.ente.photos"
        "$STATE" "PDF Arranger"      "Merge, shuffle, and crop PDFs"     "com.github.jeromerobert.pdfarranger"
        "$STATE" "Czkawka"           "Find duplicates, empty folders"    "com.github.qarmin.czkawka"
        "$STATE" "Musicfetch"        "Download songs and tag them"       "net.fhannenheim.musicfetch"
        "$STATE" "Shortwave"         "Listen to internet radio"          "de.haeckerfelix.Shortwave"
        "$STATE" "Brasero"           "Create and copy CDs and DVDs"      "org.gnome.Brasero"
        "$STATE" "Gapless"           "Play your music elegantly"         "com.github.neithern.g4music"
        "$STATE" "Impression"        "Create bootable drives"            "io.gitlab.adhami3310.Impression"
        "$STATE" "Haruna"            "Media player"                      "org.kde.haruna"
        "$STATE" "LibreOffice"       "Productivity suite"                "org.libreoffice.LibreOffice"
        "$STATE" "Extension Manager" "Install GNOME Extensions"          "com.mattjakeman.ExtensionManager"
        "$STATE" "Gramps"            "Genealogical research"             "org.gramps_project.Gramps"
    )

    choices=$(yad --title="$APP_TITLE" --list --checklist \
        --width=850 --height=550 --center \
        --column="Select" \
        --column="App Name" \
        --column="Description" \
        --column="ID" \
        --hide-column=4 \
        --button="Select All:2" \
        --button="Unselect All:3" \
        --button="Install:0" \
        --button="Cancel:1" \
        "${APPS[@]}" \
        --separator='|')

    exit_status=$?

    case $exit_status in
        2) install_flatpaks "TRUE" ; return ;;
        3) install_flatpaks "FALSE" ; return ;;
        0) ;; 
        *) return ;; 
    esac

    [[ -z "$choices" ]] && return

    selected_ids=$(echo "$choices" | tr '|' '\n' | grep '\.')

    if [[ -n "$selected_ids" ]]; then
        total_apps=$(echo "$selected_ids" | wc -l)
        current_count=0

        (
        echo "# Starting installation..."
        for id in $selected_ids; do
            current_count=$((current_count + 1))
            percentage=$(( current_count * 100 / total_apps ))
            echo "# Installing $id ($current_count of $total_apps)..."

            # --- TERMINAL OUTPUT ENABLED ---
            # We use 'tee' to send the output to the terminal AND keep the logic flowing
            echo "--- Installing $id ---" > /dev/tty
            flatpak install -y flathub "$id" > /dev/tty 2>&1

            echo "$percentage"
        done
        echo "# All apps installed! 🎉"
        echo "100"
        sleep 1
        ) | yad --title="$APP_TITLE" --progress --width=400 --center --auto-close --percentage=0

        yad --title="$APP_TITLE" --text="Installation Complete! Check terminal for details." --button=OK --center
    fi
}

export -f toggle_theme install_flatpaks

#######################################
# Main menu loop
#######################################
trap "pkill -f 'yad.*$APP_TITLE'; continue" USR1

while true; do
    export GTK_THEME=$(cat "$THEME_FILE")

    THEME_LABEL="🌙 Dark Mode"
    [[ "$GTK_THEME" == "Adwaita-dark" ]] && THEME_LABEL="☀️ Light Mode"

    yad --form --title="$APP_TITLE" \
        --width=400 --height=350 --center \
        --columns=2 \
        --field="👋 Welcome":FBTN "bash -c 'echo \"Hello Ricky!\" > /dev/tty; yad --text=\"Hi Ricky!\" --button=OK --center'" \
        --field="⬆️ Update":FBTN "bash -c 'echo \"--- Starting System Update ---\" > /dev/tty; sudo apt update && sudo apt upgrade -y; yad --text=\"System Updated\" --button=OK --center'" \
        --field="🧲 Fix Dock":FBTN "bash -c 'echo \"Updating Dock Settings...\" > /dev/tty; gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM; gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true; gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false; echo \"Done.\" > /dev/tty'" \
        --field="📦 Flatpak Support":FBTN "bash -c 'echo \"Enabling Flatpak Support...\" > /dev/tty; sudo apt install -y flatpak && sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; yad --text=\"Flatpak Ready\" --button=OK --center'" \
        --field="⭐ Install Flatpaks":FBTN "bash -c 'install_flatpaks'" \
        --field="$THEME_LABEL":FBTN "bash -c 'toggle_theme'" \
        --button="❌ Close":1

    ret=$?
    if [[ $ret -eq 1 || $ret -eq 252 ]]; then
        break
    fi
done