#!/usr/bin/env bash
set -e

# Green text helper + pause
green_echo() {
  echo -e "\e[32m$1\e[0m"
  sleep 3
}

green_echo "Updating system..."
sudo apt update && sudo apt upgrade -y

green_echo "Fixing Ubuntu Dock..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

green_echo "Installing Flatpak Support..."
sudo apt install -y flatpak

green_echo "Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo
printf "\033[33m👉 Install Adam's must-have Flatpaks? (y/N): \033[0m"
read INSTALL_FLATPAKS
echo


if [[ "$INSTALL_FLATPAKS" =~ ^([yY]|[yY][eE][sS])$ ]]; then
  green_echo "Installing Adam's Must-Have Flatpaks..."

  green_echo "Flatpak 1: Mission Center"
  flatpak install -y flathub io.missioncenter.MissionCenter

  green_echo "Flatpak 2: PLACEHOLDER"
  # flatpak install -y flathub com.example.App

else
  green_echo "Skipping Flatpak installs."
fi

green_echo "Done! You may need to log out and log back in for GNOME changes to fully apply."
