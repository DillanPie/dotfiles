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

EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"

# Ensure necessary directories exist
mkdir -p "$BACKUP_DIR" "$EXTENSIONS_DIR"

echo "Starting dotfiles installation..."

# 🖥️ **Enable GNOME Extensions Support**
echo "Enabling user GNOME extensions..."
gsettings set org.gnome.shell disable-user-extensions false

# 🧩 **GNOME Extensions to Install**
EXTENSIONS_LIST=(
    "appindicatorsupport@rgcjonas.gmail.com"
    "dash-to-dock@micxgx.gmail.com"
    "clipboard-indicator@tudmotu.com"
    "caffeine@patapon.info"
    "mediacontrols@cliffniff.github.com"
    "openweather-extension@penguin-teal.github.io"
    "hidetopbar@mathieu.bidon.ca"
)

echo "Installing GNOME Extensions from extensions.gnome.org..."
for EXTENSION in "${EXTENSIONS_LIST[@]}"; do
    EXTENSION_NAME=$(echo "$EXTENSION" | awk -F'@' '{print $1}')
    EXTENSION_ID=$(curl -s "https://extensions.gnome.org/extension-query/?search=$EXTENSION_NAME" | jq -r '.extensions[0].id')

    if [ -z "$EXTENSION_ID" ] || [ "$EXTENSION_ID" == "null" ]; then
        echo "⚠️ Could not find $EXTENSION on extensions.gnome.org. Skipping..."
        continue
    fi

    echo "Downloading $EXTENSION..."
    wget -O "/tmp/$EXTENSION_NAME.zip" "https://extensions.gnome.org/extension-data/$EXTENSION_NAME.shell-extension.zip"

    echo "Installing $EXTENSION..."
    gnome-extensions install "/tmp/$EXTENSION_NAME.zip" || echo "⚠️ Failed to install $EXTENSION"
done

# ✅ **Enable Installed Extensions**
echo "Enabling GNOME Extensions..."
for EXTENSION in "${EXTENSIONS_LIST[@]}"; do
    if gnome-extensions list | grep -q "$EXTENSION"; then
        echo "Enabling $EXTENSION..."
        gnome-extensions enable "$EXTENSION" || echo "⚠️ Failed to enable $EXTENSION"
    else
        echo "⚠️ $EXTENSION is missing! Check if it was installed properly."
    fi
done

echo "GNOME Extensions installed and enabled successfully!"

# Install GNOME dependencies and themes using yay
yay -S --needed --noconfirm \
    gnome-tweaks\
    papirus-icon-theme \
    bibata-cursor-theme \
    ttf-firacode-nerd

# Ensure required directories exist
mkdir -p ~/.themes ~/.icons ~/.local/share/fonts

echo "Setting up GNOME themes, icons, fonts, and cursors..."
echo "Downloading and installing Gruvbox GTK Theme..."

# Define theme download location
GTK_THEME_REPO="https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git"
GTK_THEME_DIR="$HOME/.themes/Gruvbox-Dark"

# Ensure the themes directory exists
mkdir -p "$HOME/.themes"

# Check if the theme is already installed
if [ -d "$GTK_THEME_DIR" ]; then
    echo "Gruvbox GTK Theme is already installed. Pulling latest changes..."
    cd "$GTK_THEME_DIR" && git pull
else
    echo "Cloning Gruvbox GTK Theme..."
    git clone --depth 1 "$GTK_THEME_REPO" "$GTK_THEME_DIR"
fi

# Apply the theme
echo "Applying Gruvbox GTK Theme..."
dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Dark"

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
