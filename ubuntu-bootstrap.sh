#!/usr/bin/env bash
set -e


#!#########################     Variables      ######################################

# Green text helper + pause
green_echo() {
  echo -e "\e[32m$1\e[0m"
  sleep 3
}

#!#########################     Update      ######################################
green_echo "Hi Ricky Red Car 🚗 I made this interactive script for you to try, Enjoy!😀"

green_echo "Updating system..."
sudo apt update && sudo apt upgrade -y

#!#########################     Ubuntu Dock      ######################################

green_echo "Fixing Ubuntu Dock..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false


#!#########################     Flatpaks       ######################################
green_echo "Installing Flatpak Support..."
sudo apt install -y flatpak

green_echo "Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo
echo "The following Flatpaks will be installed:"
echo "  Flatpak 1: Mail Viewer - EML and MSG file viewer"
echo "  Flatpak 2: Fred TV - Fast And Powerful IPTV App"
echo "  Flatpak 3: gThumb - Image Viewer"
echo "  Flatpak 4: ZapZap - WhatsApp Messenger"
echo "  Flatpak 5 - Ente Photos - Safe home for your photos"
echo "  Flatpak 6 - PDF Arranger - Merge, shuffle, and crop PDFs"
echo "  Flatpak 7 - Czkawka -  find duplicates, empty folders, similar images, broken files etc."
echo "  Flatpak 8 - Musicfetch - Download songs and tag them"
echo "  Flatpak 9 - Shortwave - Listen to internet radio"
echo "  Flatpak 9 - Brasero - Create and copy CDs and DVDs"
echo "  Flatpak 9 - Gapless - Play your music elegantly"
echo "  Flatpak 9 - Impression - Create bootable drives"
echo "  Flatpak 9 - Haruna - Media player"
echo "  Flatpak 9 - LibreOffice - The LibreOffice productivity suite"
echo "  Flatpak 9 - Extension Manager - Install GNOME Extensions - The LibreOffice productivity suite"
echo "  Flatpak 9 - Gramps - perform genealogical research and analysis"
echo

printf "\033[33m👉 Install Adam's must-have Flatpaks? (y/N): \033[0m"
read INSTALL_FLATPAKS
echo


  flatpak install -y flathub io.github.alescdb.mailviewer
  flatpak install flathub dev.fredol.open-tv
  flatpak install flathub org.gnome.gThumb
  flatpak install flathub com.rtosta.zapzap
  flatpak install flathub io.ente.photos
  flatpak install flathub com.github.jeromerobert.pdfarranger
  flatpak install flathub com.github.qarmin.czkawka
  flatpak install flathub net.fhannenheim.musicfetch
  flatpak install flathub de.haeckerfelix.Shortwave
  flatpak install flathub org.gnome.Brasero
  flatpak install flathub com.github.neithern.g4music
  flatpak install flathub io.gitlab.adhami3310.Impression
  flatpak install flathub org.kde.haruna
  flatpak install flathub org.libreoffice.LibreOffice
  flatpak install flathub com.mattjakeman.ExtensionManager
  flatpak install flathub org.gramps_project.Gramps


else
  green_echo "Skipping Flatpak installs."
fi

#!#########################     Done       ######################################

green_echo "Done! You may need to log out and log back in for GNOME changes to fully apply."
