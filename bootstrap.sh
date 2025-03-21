#!/bin/bash

# bootstrap.sh - Prepares a fresh Arch Linux install for your dotfiles setup

set -e  # Exit on error

# Colors for nice output
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
  echo -e "${YELLOW}Do NOT run this script as root or with sudo!${RESET}"
  echo "Instead, run this as your regular user (e.g., test, DillanPie, etc.)."
  exit 1
fi

echo -e "${GREEN}Starting bootstrap process...${RESET}"

# Update the system
echo -e "${YELLOW}Updating system...${RESET}"
sudo pacman -Syu --noconfirm

# Install essential packages
echo -e "${YELLOW}Installing essential packages...${RESET}"
sudo pacman -S --needed --noconfirm git base-devel wget curl zsh

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is not installed. Installing git...${RESET}"
    sudo pacman -S git --noconfirm
fi

# Install yay if not already installed
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Installing yay (AUR Helper)...${RESET}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    echo -e "${GREEN}yay installed successfully!${RESET}"
else
    echo -e "${GREEN}yay is already installed. ✅${RESET}"
fi

# Install Full GNOME Desktop Environment
echo -e "${YELLOW}Installing full GNOME desktop environment...${RESET}"
sudo pacman -S --needed --noconfirm gnome gnome-extra gdm

# Enable GDM (GNOME Display Manager)
echo -e "${YELLOW}Enabling GDM (Login Manager)...${RESET}"
sudo systemctl enable gdm
sudo systemctl start gdm

# Install Zsh if not installed
if ! command -v zsh &> /dev/null; then
    echo -e "${YELLOW}Installing Zsh...${RESET}"
    sudo pacman -S zsh --noconfirm
fi

# Install Oh-My-Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh-My-Zsh...${RESET}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install AUR packages via yay
echo -e "${YELLOW}Installing AUR packages (Spotify, Spicetify, Fastfetch)...${RESET}"
yay -S --needed --noconfirm spotify spicetify-cli fastfetch

# Clone your dotfiles repo if not already cloned
if [ ! -d "$HOME/.dotfiles" ]; then
    echo -e "${YELLOW}Cloning your dotfiles repo...${RESET}"
    git clone https://github.com/DillanPie/dotfiles.git ~/.dotfiles
else
    echo -e "${GREEN}Dotfiles repo already exists at ~/.dotfiles ✅${RESET}"
fi

# Install GNOME Extensions from your repo (if they exist)
if [ -d "$HOME/.dotfiles/gnome/extensions" ]; then
    echo -e "${YELLOW}Installing GNOME Extensions...${RESET}"
    EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
    mkdir -p "$EXTENSIONS_DIR"
    cp -r "$HOME/.dotfiles/gnome/extensions/"* "$EXTENSIONS_DIR/"
    
    echo -e "${YELLOW}Enabling GNOME Extensions...${RESET}"
    for extension in "$EXTENSIONS_DIR"/*; do
        if [ -d "$extension" ]; then
            extension_name=$(basename "$extension")
            gnome-extensions enable "$extension_name" || echo "Failed to enable $extension_name"
        fi
    done
fi

# Apply GNOME Settings
echo -e "${YELLOW}Applying GNOME settings...${RESET}"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Gruvbox-Dark"
gsettings set org.gnome.shell.extensions.user-theme name "Gruvbox-Dark"

# Run the install script from your dotfiles repo
echo -e "${YELLOW}Running your install.sh script...${RESET}"
bash ~/.dotfiles/install.sh

echo -e "${GREEN}Bootstrap process completed successfully! 🎉${RESET}"
