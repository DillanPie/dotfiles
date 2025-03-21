#!/bin/bash

# install.sh - Sets up dotfiles, GNOME settings, yay, Spicetify, Fastfetch, and Oh-My-Zsh

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"

# Files and directories to symlink
declare -a FILES=(".bashrc" ".vimrc" ".zshrc")
declare -a DIRECTORIES=("config/nvim")

# GNOME Directories
GNOME_EXTENSIONS="$HOME/.local/share/gnome-shell/extensions"
GNOME_THEMES="$HOME/.themes"
GNOME_ICONS="$HOME/.icons"
WALLPAPER_DEST="$HOME/Pictures/wallpaper.png"

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

        echo "yay installed successfully!"
    else
        echo "yay is already installed. ✅"
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

# Symlink config directories
for dir in "${DIRECTORIES[@]}"; do
    TARGET_DIR="$HOME/.config/$(basename "$dir")"
    if [ -d "$TARGET_DIR" ]; then
        echo "Backing up existing $TARGET_DIR to $BACKUP_DIR"
        mv "$TARGET_DIR" "$BACKUP_DIR"
    fi

    echo "Creating symlink for $TARGET_DIR"
    ln -sfn "$DOTFILES_DIR/$dir" "$TARGET_DIR"
done

# Install yay if not already installed
install_yay

# Install necessary packages via yay
echo "Installing necessary packages via yay..."
yay -S --needed --noconfirm bibata-cursor-theme papirus-icon-theme gruvbox-material-gtk-theme gruvbox-dark-gtk ttf-firacode-nerd spicetify-cli fastfetch zsh

# Apply GNOME Settings
echo "Applying GNOME settings..."
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.shell.extensions.user-theme name "Gruvbox-Dark"
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
gsettings set org.gnome.desktop.interface font-name "FiraCode Nerd Font 11"
gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font 11"

# Copy wallpaper to Pictures directory
echo "Copying wallpaper..."
cp "$DOTFILES_DIR/wallpaper.png" "$WALLPAPER_DEST"

# Set the wallpaper
echo "Setting wallpaper..."
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DEST"

# Install Spicetify themes
echo "Installing Spicetify themes..."
mkdir -p ~/.config/spicetify/Themes
cp -r "$DOTFILES_DIR/spicetify/"* ~/.config/spicetify/Themes/
spicetify config current_theme YourThemeName
spicetify apply

# Install Fastfetch configuration
echo "Installing Fastfetch config..."
mkdir -p ~/.config/fastfetch
cp -r "$DOTFILES_DIR/fastfetch/"* ~/.config/fastfetch/

# Copy Oh-My-Zsh theme
echo "Installing Oh-My-Zsh theme..."
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
cp -r "$DOTFILES_DIR/oh-my-zsh/theme/"* "$HOME/.oh-my-zsh/custom/themes/"

# Change default shell to zsh if not already
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Changing default shell to zsh..."
    chsh -s /bin/zsh
fi

echo "Dotfiles and configurations installed successfully! 🎉"
