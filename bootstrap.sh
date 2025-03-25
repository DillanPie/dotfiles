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
  exit 1
fi

echo -e "${GREEN}Starting bootstrap process...${RESET}"

# Update the system
echo -e "${YELLOW}Updating system...${RESET}"
sudo pacman -Syu --noconfirm

# Install essential packages
echo -e "${YELLOW}Installing essential packages...${RESET}"
sudo pacman -S --needed --noconfirm git base-devel wget curl zsh gnome-shell gnome-control-center gdm nautilus dconf-editor gnome-terminal gnome-tweaks gnome-shell-extensions

# Enable GDM (But do NOT start it yet)
sudo systemctl enable gdm

# Install yay (if not installed)
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Installing yay...${RESET}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
fi

# Install AUR packages via yay
yay -S --needed --noconfirm spotify spicetify-cli fastfetch extension-manager

# Install Oh-My-Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh-My-Zsh...${RESET}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Run install.sh
echo -e "${YELLOW}Running install.sh script...${RESET}"
bash ~/.dotfiles/install.sh

# Start GDM
sudo systemctl start gdm
