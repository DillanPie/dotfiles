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

echo "Installing GNOME Extensions from the AUR..."

# List of extensions to install from the AUR
EXTENSIONS=(
    gnome-shell-extension-dash-to-dock
    gnome-shell-extension-appindicator
    gnome-shell-extension-user-themes
    gnome-shell-extension-caffeine
    gnome-shell-extension-clipboard-indicator
    gnome-shell-extension-openweatherrefined
    gnome-shell-extension-hidetopbar-git
)

# Install extensions using yay
yay -S --needed --noconfirm "${EXTENSIONS[@]}"

echo "✅ GNOME Extensions installed successfully!"

# Enable installed extensions
for EXT in "${EXTENSIONS[@]}"; do
    EXT_NAME=$(echo "$EXT" | sed 's/gnome-shell-extension-//')
    if gnome-extensions list | grep -q "$EXT_NAME"; then
        echo "✅ Enabling $EXT_NAME..."
        gnome-extensions enable "$EXT_NAME"
    else
        echo "⚠️ Could not find installed extension $EXT_NAME!"
    fi
done

echo "🎉 GNOME Extensions are now installed and enabled!"


# Install GNOME dependencies and themes
yay -S --needed --noconfirm \
    gnome-tweaks \
    papirus-icon-theme \
    bibata-cursor-theme \
    ttf-firacode-nerd \
    sassc \
    gtk-engine-murrine \
    gnome-themes-extra

# Ensure required directories exist
mkdir -p ~/.themes ~/.icons ~/.local/share/fonts

echo "Setting up GNOME themes, icons, fonts, and cursors..."
echo "Downloading and installing Gruvbox GTK Theme..."

# Define theme download location
GTK_THEME_REPO="https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git"
GTK_THEME_DIR="$HOME/.themes/Gruvbox-Dark"

cd $HOME/.themes
git clone $GTK_THEME_REPO
cd Gruvbox-GTK-Theme/themes
./build.sh
./gtkrc.sh
./install.sh
cd

echo "Gruvbox GTK Theme installed and applied successfully!"

# Apply GNOME theme settings
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Gruvbox-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface font-name "FiraCode Nerd Font 11"
gsettings set org.gnome.desktop.interface document-font-name "FiraCode Nerd Font 11"
gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font Mono 10"
gsettings set org.gnome.desktop.interface font-hinting "none"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface accent-color "green"

# Enable animations
gsettings set org.gnome.desktop.interface enable-animations true

# Hide battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage false

echo "GNOME theme and appearance setup completed!"

# ✅ **Restart GNOME Shell**
echo "Restarting GNOME Shell..."
sleep 5
killall -3 gnome-shell || echo "⚠️ Failed to restart GNOME Shell. Try logging out and back in."

echo "Dotfiles and configurations applied successfully! 🎉"
