#!/usr/bin/env bash
set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing GNOME extensions support and Dash to Dock..."
sudo apt install -y gnome-shell-extension-dash-to-dock gnome-shell-extensions gnome-tweaks

echo "Enabling Dash to Dock..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com || true

echo "Moving dock to the bottom..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

echo "Installing Flatpak..."
sudo apt install -y flatpak

echo "Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing Mission Center..."
flatpak install -y flathub io.missioncenter.MissionCenter

echo "Done! You may need to log out and log back in for GNOME changes to fully apply."
