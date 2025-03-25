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
echo -e "${YELLOW}Updating system packages...${RESET}"
sudo pacman -Syu --noconfirm

# Install essential packages (Base + AUR Support + GNOME)
echo -e "${YELLOW}Installing base system and essential packages...${RESET}"
sudo pacman -S --needed --noconfirm base base-devel git wget curl zsh

# Install the full GNOME desktop environment
echo -e "${YELLOW}Installing the GNOME desktop environment...${RESET}"
sudo pacman -S --needed --noconfirm gnome gnome-extra

# Enable GDM (But do NOT start it yet)
echo -e "${YELLOW}Enabling GDM (GNOME Display Manager)...${RESET}"
sudo systemctl enable gdm

# Install yay (if not installed)
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Installing yay (AUR Helper)...${RESET}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
fi

# Install AUR packages via yay
echo -e "${YELLOW}Installing AUR packages (Spotify, Spicetify, Fastfetch, Extension Manager)...${RESET}"
yay -S --needed --noconfirm spotify spicetify-cli fastfetch extension-manager

# Install Oh-My-Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh-My-Zsh...${RESET}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Clone dotfiles if not already cloned
if [ ! -d "$HOME/.dotfiles" ]; then
    echo -e "${YELLOW}Cloning your dotfiles repository...${RESET}"
    git clone https://github.com/DillanPie/dotfiles.git ~/.dotfiles
else
    echo -e "${GREEN}Dotfiles repository already exists. Skipping cloning. ✅${RESET}"
fi

# Run install.sh to apply dotfiles and settings
echo -e "${YELLOW}Running install.sh script...${RESET}"
bash ~/.dotfiles/install.sh

# Start GDM to launch GNOME
echo -e "${YELLOW}Starting GDM...${RESET}"
sudo systemctl start gdm

echo -e "${GREEN}Bootstrap process completed successfully! 🎉${RESET}"
