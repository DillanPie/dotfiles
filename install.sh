#!/bin/bash

# install.sh - Sets up your dotfiles, GNOME settings, Spicetify, Fastfetch, Oh-My-Zsh, and more.

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"

# Files and directories to symlink
declare -a FILES=(".bashrc" ".vimrc" ".zshrc")
declare -a DIRECTORIES=("config/nvim" "oh-my-zsh" "spicetify" "fastfetch")

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

# Apply GNOME Settings
echo "Applying GNOME settings..."
dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
dbus-launch gsettings set org.gnome.desktop.interface font-name "FiraCode Nerd Font 11"
dbus-launch gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font 11"

# Apply GNOME Shell Theme (User Theme Extension must be enabled first)
if gnome-extensions list | grep -q "user-theme"; then
    dbus-launch gsettings set org.gnome.shell.extensions.user-theme name "Gruvbox-Dark"
else
    echo "User Theme extension is not enabled. Trying to enable..."
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || echo "Failed to enable User Theme extension!"
fi

# Install GNOME Extensions (if present in dotfiles)
echo "Installing GNOME Extensions..."
EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$EXTENSIONS_DIR"
if [ -d "$DOTFILES_DIR/gnome/extensions" ]; then
    cp -r "$DOTFILES_DIR/gnome/extensions/"* "$EXTENSIONS_DIR/"
    for extension in "$EXTENSIONS_DIR"/*; do
        if [ -d "$extension" ]; then
            extension_name=$(basename "$extension")
            gnome-extensions enable "$extension_name" || echo "Failed to enable $extension_name"
        fi
    done
fi

# Apply Spicetify Theme
echo "Applying Spicetify theme..."
mkdir -p ~/.config/spicetify/Themes
cp -r "$DOTFILES_DIR/spicetify/"* ~/.config/spicetify/Themes/
spicetify config current_theme Dribbblish Gruvbox
spicetify apply
pkill spotify || echo "Spotify was not running"

# Ensure Zsh is the default shell
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

# Install Oh-My-Zsh Theme
echo "Applying Oh-My-Zsh Theme..."
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
cp "$DOTFILES_DIR/oh-my-zsh/theme/gruvbox.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/gruvbox.zsh-theme"
cp "$DOTFILES_DIR/oh-my-zsh/.zshrc" "$HOME/.zshrc"

echo "Dotfiles and configurations applied successfully! 🎉"
