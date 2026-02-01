#!/usr/bin/env bash

export GTK_THEME=Adwaita-dark
APP_TITLE="Ricky Red Car Setup 🚗"

#######################################
# Progress runner (FIXED)
#######################################
run_with_progress() {
  (
    echo "10"
    bash -c "$1"
    echo "100"
  ) | yad --progress \
      --title="$APP_TITLE" \
      --text="Working…" \
      --percentage=0 \
      --auto-close \
      --auto-kill \
      --center
}

#######################################
# Actions
#######################################
welcome() {
  yad --title="$APP_TITLE" \
      --text="Hi Ricky Red Car 🚗\n\nClick a button to run each task.\nNothing runs automatically." \
      --button=OK \
      --center
}

update_system() {
  run_with_progress "sudo apt update && sudo apt upgrade -y"
}

fix_dock() {
  run_with_progress "
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
  "
}

flatpak_support() {
  run_with_progress "
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  "
}

install_flatpaks() {
  yad --title="$APP_TITLE" \
      --text="Install Adam's must-have Flatpaks?" \
      --button="Install:0" \
      --button="Cancel:1" \
      --center

  [ $? -ne 0 ] && return

  run_with_progress "
    flatpak install -y flathub io.github.alescdb.mailviewer
    flatpak install -y flathub dev.fredol.open-tv
    flatpak install -y flathub org.gnome.gThumb
    flatpak install -y flathub com.rtosta.zapzap
    flatpak install -y flathub io.ente.photos
    flatpak install -y flathub com.github.jeromerobert.pdfarranger
    flatpak install -y flathub com.github.qarmin.czkawka
    flatpak install -y flathub net.fhannenheim.musicfetch
    flatpak install -y flathub de.haeckerfelix.Shortwave
    flatpak install -y flathub org.gnome.Brasero
    flatpak install -y flathub com.github.neithern.g4music
    flatpak install -y flathub io.gitlab.adhami3310.Impression
    flatpak install -y flathub org.kde.haruna
    flatpak install -y flathub org.libreoffice.LibreOffice
    flatpak install -y flathub com.mattjakeman.ExtensionManager
    flatpak install -y flathub org.gramps_project.Gramps
  "
}

#######################################
# Main menu loop
#######################################
while true; do
  yad --title="$APP_TITLE" \
      --text="Choose an action:" \
      --button="👋 Welcome":1 \
      --button="⬆️ Update System":2 \
      --button="🧲 Fix Dock":3 \
      --button="📦 Flatpak Support":4 \
      --button="⭐ Install Flatpaks":5 \
      --button="❌ Exit":0 \
      --width=420 \
      --center

  case $? in
    1) welcome ;;
    2) update_system ;;
    3) fix_dock ;;
    4) flatpak_support ;;
    5) install_flatpaks ;;
    0) break ;;
  esac
done

yad --title="$APP_TITLE" \
    --text="Done 🚀\nYou may need to log out and back in." \
    --button=OK \
    --center
s