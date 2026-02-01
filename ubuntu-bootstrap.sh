#!/usr/bin/env bash
set -e


#!#########################     Variables      ######################################

# Green text helper + pause
green_echo() {
  echo -e "\e[32m$1\e[0m"
  sleep 3
}

#!#########################     Update      ######################################
green_echo "Hi Rick I made this interactive script for you to try, Enjoy!"

green_echo "Updating system..."
sudo apt update && sudo apt upgrade -y

##########################     Ubuntu Dock      ######################################

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
echo "  Flatpak 1: Mission Center"
echo "  Flatpak 2: Flatseal"
echo "  Flatpak 3: GNOME Calculator"
echo

printf "\033[33m👉 Install Adam's must-have Flatpaks? (y/N): \033[0m"
read INSTALL_FLATPAKS
echo



if [[ "$INSTALL_FLATPAKS" =~ ^([yY]|[yY][eE][sS])$ ]]; then
  green_echo "Installing Adam's Must-Have Flatpaks..."

  flatpak install -y flathub io.missioncenter.MissionCenter


else
  green_echo "Skipping Flatpak installs."
fi

#!#########################     Done       ######################################

green_echo "Done! You may need to log out and log back in for GNOME changes to fully apply."
