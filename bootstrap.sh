#!/bin/bash

# bootstrap.sh - Prepares a fresh Arch Linux install for your dotfiles setup

set -e  # Exit on error

# Colors for nice output
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
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

# Refresh yay database and install Extension Manager
echo -e "${YELLOW}Installing Extension Manager...${RESET}"
yay -Sy --needed --noconfirm extension-manager

# Install Core GNOME (Without Extra Packages)
echo -e "${YELLOW}Installing core GNOME desktop environment...${RESET}"
sudo pacman -S --needed --noconfirm gnome-shell gnome-control-center gdm gnome-backgrounds nautilus dconf-editor gnome-terminal

# Install gnome-shell-extensions (User Themes)
echo -e "${YELLOW}Installing GNOME Shell Extensions (user-theme)...${RESET}"
sudo pacman -S --needed --noconfirm gnome-shell-extensions

# Enable GDM (But DO NOT Start It Yet)
echo -e "${YELLOW}Enabling GDM (Login Manager)...${RESET}"
sudo systemctl enable gdm

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

# Copy Oh-My-Zsh theme from .dotfiles to correct directory
echo -e "${YELLOW}Installing your Oh-My-Zsh theme...${RESET}"
if [ -d "$HOME/.dotfiles/oh-my-zsh/themes" ]; then
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    cp -r "$HOME/.dotfiles/oh-my-zsh/themes/"* "$HOME/.oh-my-zsh/custom/themes/"
else
    echo -e "${RED}Oh-My-Zsh theme folder not found! Make sure ~/.dotfiles/oh-my-zsh/themes/ exists.${RESET}"
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

# Enable the User Themes Extension
echo -e "${YELLOW}Enabling User Themes Extension...${RESET}"
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# Apply GNOME Settings
echo -e "${YELLOW}Applying GNOME settings...${RESET}"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Gruvbox-Dark"
gsettings set org.gnome.shell.extensions.user-theme name "Gruvbox-Dark"

# Apply GNOME Extension Settings (If Present)
if [ -f "$HOME/.dotfiles/gnome/gnome-settings.conf" ]; then
    echo -e "${YELLOW}Applying GNOME extension settings...${RESET}"
    dconf load / < "$HOME/.dotfiles/gnome/gnome-settings.conf"
fi

# Run the install script from your dotfiles repo
echo -e "${YELLOW}Running your install.sh script...${RESET}"
bash ~/.dotfiles/install.sh

# Start GDM Now That Everything Is Done
echo -e "${YELLOW}Starting GDM...${RESET}"
sudo systemctl start gdm

echo -e "${GREEN}Bootstrap process completed successfully! 🎉${RESET}"
