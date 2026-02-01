#!/usr/bin/env bash
set -e

# Green text helper + 2 second pause
green_echo() {
  echo -e "\e[32m$1\e[0m"
  sleep 2
}

green_echo "Updating system..."
sudo apt update && sudo apt upgrade -y

green_echo "Installing GNOME extensions support and Dash to Dock..."
sudo apt install -y gnome-shell-extension-dash-to-dock gnome-shell-extensions gnome-tweaks

green_echo "Enabling Dash to Dock..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com || true

green_echo "Moving dock to the bottom..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

green_echo "Installing Flatpak..."
sudo apt install -y flatpak

green_echo "Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

green_echo "Installing Mission Center..."
flatpak install -y flathub io.missioncenter.MissionCenter

green_echo "Done! You may need to log out and log back in for GNOME changes to fully apply."
