#!/bin/bash

# bootstrap.sh - Prepares a fresh Arch Linux install for your dotfiles setup

set -e  # Exit on error

# Colors for nice output
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN}Starting bootstrap process...${RESET}"

# Update the system
echo -e "${YELLOW}Updating system...${RESET}"
sudo pacman -Syu --noconfirm

# Install essential packages
echo -e "${YELLOW}Installing essential packages...${RESET}"
sudo pacman -S --needed --noconfirm git base-devel wget curl zsh gnome-shell gnome-control-center

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

# Install GNOME if not installed
if ! command -v gnome-shell &> /dev/null; then
    echo -e "${YELLOW}Installing GNOME packages...${RESET}"
    sudo pacman -S gnome gnome-extra --noconfirm
fi

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

# Clone your dotfiles repo if not already cloned
if [ ! -d "$HOME/.dotfiles" ]; then
    echo -e "${YELLOW}Cloning your dotfiles repo...${RESET}"
    git clone https://github.com/DillanPie/dotfiles.git ~/.dotfiles
else
    echo -e "${GREEN}Dotfiles repo already exists at ~/.dotfiles ✅${RESET}"
fi

# Run the install script from your dotfiles repo
echo -e "${YELLOW}Running your install.sh script...${RESET}"
bash ~/.dotfiles/install.sh

echo -e "${GREEN}Bootstrap process completed successfully! 🎉${RESET}"
