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

echo "Installing GNOME Extensions..."

GNOME_EXT_LIST="$DOTFILES_DIR/gnome/extensions"
USER_EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
GNOME_CONFIG="$DOTFILES_DIR/gnome/gnome-settings.conf"

# Ensure extension directory exists
mkdir -p "$USER_EXT_DIR"

echo "🔍 Reading GNOME Extensions from $GNOME_EXT_LIST..."

if [ ! -d "$GNOME_EXT_LIST" ]; then
    echo "❌ No GNOME extensions directory found in $GNOME_EXT_LIST!"
    exit 1
fi

# 🧩 **Find and Install Extensions from `extensions.gnome.org`**
for EXTENSION in "$GNOME_EXT_LIST"/*; do
    EXTENSION_NAME=$(basename "$EXTENSION")

    echo "🔎 Searching for $EXTENSION_NAME on extensions.gnome.org..."
    EXTENSION_ID=$(curl -s "https://extensions.gnome.org/extension-query/?search=$EXTENSION_NAME" | jq -r '.extensions[0].id')

    if [ -z "$EXTENSION_ID" ] || [ "$EXTENSION_ID" == "null" ]; then
        echo "⚠️ Could not find $EXTENSION_NAME on extensions.gnome.org! Skipping..."
        continue
    fi

    echo "📥 Downloading $EXTENSION_NAME..."
    wget -O "/tmp/$EXTENSION_NAME.zip" "https://extensions.gnome.org/extension-data/$EXTENSION_NAME.shell-extension.zip"

    echo "📦 Installing $EXTENSION_NAME..."
    gnome-extensions install "/tmp/$EXTENSION_NAME.zip" || echo "⚠️ Failed to install $EXTENSION_NAME"
done

# ✅ **Enable Installed Extensions**
echo "✅ Enabling GNOME Extensions..."
for EXTENSION in "$GNOME_EXT_LIST"/*; do
    EXTENSION_NAME=$(basename "$EXTENSION")
    if gnome-extensions list | grep -q "$EXTENSION_NAME"; then
        echo "✅ Enabling $EXTENSION_NAME..."
        gnome-extensions enable "$EXTENSION_NAME" || echo "⚠️ Failed to enable $EXTENSION_NAME"
    else
        echo "⚠️ Extension $EXTENSION_NAME is missing or not recognized!"
    fi
done

echo "🎉 GNOME Extensions installed and enabled successfully!"

# 🛠 **Apply GNOME Settings from `gnome-settings.conf`**
if [ -f "$GNOME_CONFIG" ]; then
    echo "⚙ Applying GNOME settings from $GNOME_CONFIG..."
    dconf load / < "$GNOME_CONFIG"
    echo "✅ GNOME settings applied successfully!"
else
    echo "⚠️ No GNOME settings file found at $GNOME_CONFIG!"
fi

# Install GNOME dependencies and themes using yay
yay -S --needed --noconfirm \
    gnome-tweaks\
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
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git

cd Gruvbox-GTK-Theme
cd themes
./build.sh
./gtkrc.sh
.install.sh
cd

echo "Gruvbox GTK Theme installed and applied successfully!"

# Apply GNOME theme settings after login
dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Dark"
dbus-launch gsettings set org.gnome.desktop.wm.preferences theme "Gruvbox-Dark"
dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
dbus-launch gsettings set org.gnome.desktop.interface font-name "FiraCode Nerd Font 11"
dbus-launch gsettings set org.gnome.desktop.interface document-font-name "FiraCode Nerd Font 11"
dbus-launch gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font Mono 10"
dbus-launch gsettings set org.gnome.desktop.interface font-hinting "none"
dbus-launch gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
dbus-launch gsettings set org.gnome.desktop.interface accent-color "green"

# Enable animations
dbus-launch gsettings set org.gnome.desktop.interface enable-animations true

# Hide battery percentage
dbus-launch gsettings set org.gnome.desktop.interface show-battery-percentage false

echo "GNOME theme and appearance setup completed!"

# Apply Spicetify Theme
echo "Applying Spicetify theme..."
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

echo "Setting up desktop wallpaper..."

# Define wallpaper paths
WALLPAPER_SOURCE="$DOTFILES_DIR/wallpaper.png"
WALLPAPER_DEST="$HOME/Pictures/wallpaper.png"

# Ensure Pictures directory exists
mkdir -p "$HOME/Pictures"

# Copy wallpaper if it exists
if [ -f "$WALLPAPER_SOURCE" ]; then
    cp "$WALLPAPER_SOURCE" "$WALLPAPER_DEST"
    echo "Wallpaper copied to $WALLPAPER_DEST"

    # Apply wallpaper using GNOME settings
    dbus-launch gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DEST"
    dbus-launch gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DEST"
    dbus-launch gsettings set org.gnome.desktop.background picture-options "zoom"

    echo "Wallpaper applied successfully!"
else
    echo "⚠️ Wallpaper not found at $WALLPAPER_SOURCE. Skipping..."
fi

# ✅ **Restart GNOME Shell**
echo "Restarting GNOME Shell..."
sleep 5
killall -3 gnome-shell || echo "⚠️ Failed to restart GNOME Shell. Try logging out and back in."

echo "Dotfiles and configurations applied successfully! 🎉"
