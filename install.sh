#!/bin/bash

# install.sh - Sets up dotfiles, GNOME settings, yay, Spicetify, Fastfetch, Oh-My-Zsh, fzf, and user-theme extension

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"

# Files and directories to symlink
declare -a FILES=(".bashrc" ".vimrc" ".zshrc")
declare -a DIRECTORIES=("config/nvim" ".oh-my-zsh")

# GNOME Directories
GNOME_EXTENSIONS="$HOME/.local/share/gnome-shell/extensions"
GNOME_THEMES="$HOME/.themes"
GNOME_ICONS="$HOME/.icons"

# Function to install yay
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay (AUR Helper)..."

        # Install prerequisites
        sudo pacman -S --needed --noconfirm git base-devel

        # Clone yay repo
        git clone https://aur.archlinux.org/yay.git /tmp/yay

        # Build and install yay
        cd /tmp/yay || exit
        makepkg -si --noconfirm

        # Cleanup
        cd ~
        rm -rf /tmp/yay

        echo "yay installed successfully! ✅"
    else
        echo "yay is already installed. ✅"
    fi
}

# Function to install Oh-My-Zsh if not already installed
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh-My-Zsh..."
        
        # Install zsh if not installed
        sudo pacman -S --needed --noconfirm zsh

        # Install Oh-My-Zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo "Oh-My-Zsh installed successfully! ✅"
    else
        echo "Oh-My-Zsh is already installed. ✅"
    fi
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Starting dotfiles installation..."

# Symlink regular dotfiles
for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "Backing up existing $file to $BACKUP_DIR"
        mv "$HOME/$file" "$BACKUP_DIR"
    fi

    echo "Creating symlink for $file"
    ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Symlink directories like ~/.config/nvim and ~/.oh-my-zsh
for dir in "${DIRECTORIES[@]}"; do
    TARGET_DIR="$HOME/$(basename "$dir")"
    if [ -d "$TARGET_DIR" ]; then
        echo "Backing up existing $TARGET_DIR to $BACKUP_DIR"
        mv "$TARGET_DIR" "$BACKUP_DIR"
    fi

    echo "Creating symlink for $TARGET_DIR"
    ln -sfn "$DOTFILES_DIR/$dir" "$TARGET_DIR"
done

# Install yay if not already installed
install_yay

# Install Oh-My-Zsh if not already installed
install_oh_my_zsh

# Install necessary packages via yay
echo "Installing necessary packages via yay..."
yay -S --needed --noconfirm bibata-cursor-theme papirus-icon-theme gruvbox-material-gtk-theme gruvbox-dark-gtk ttf-firacode-nerd spicetify-cli fastfetch fzf

# Install user-theme extension (if not installed)
echo "Installing user-theme extension for GNOME..."
if [ ! -d "$GNOME_EXTENSIONS/user-theme@gnome-shell-extensions.gcampax.github.com" ]; then
    sudo pacman -S --needed --noconfirm gnome-shell-extensions
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    echo "User-theme extension enabled successfully! ✅"
fi

# Apply GNOME Settings
echo "Applying GNOME settings..."
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.shell.extensions.user-theme name "Gruvbox-Dark"
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
gsettings set org.gnome.desktop.interface font-name "FiraCode Nerd Font 11"
gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font 11"

# Install Spicetify themes
echo "Installing Spicetify themes..."
mkdir -p ~/.config/spicetify/Themes
cp -r "$DOTFILES_DIR/spicetify/"* ~/.config/spicetify/Themes/

# Apply Spicetify theme
echo "Applying Spicetify theme..."
spicetify config current_theme YourThemeName
spicetify apply

# Install Fastfetch configuration
echo "Installing Fastfetch config..."
mkdir -p ~/.config/fastfetch
cp -r "$DOTFILES_DIR/fastfetch/"* ~/.config/fastfetch/

# Change default shell to Zsh
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

echo "Dotfiles and configurations installed successfully! 🎉"
