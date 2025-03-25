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

# Ensure extension directory exists
EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$EXTENSIONS_DIR"

# Install dependencies
yay -S --needed --noconfirm gnome-shell-extension-manager gnome-browser-connector

# List of extensions to install
EXTENSIONS_LIST=(
    "appindicatorsupport@rgcjonas.gmail.com"
    "caffeine@patapon.info"
    "clipboard-indicator@tudmotu.com"
    "dash-to-dock@micxgx.gmail.com"
    "hidetopbar@mathieu.bidon.ca"
    "lockscreen-extension@pratap.fastmail.fm"
    "mediacontrols@cliffniff.github.com"
    "openweather-extension@penguin-teal.github.io"
)

# Install and enable extensions
for EXTENSION in "${EXTENSIONS_LIST[@]}"; do
    echo "Checking if $EXTENSION is installed..."
    
    if gnome-extensions list | grep -q "$EXTENSION"; then
        echo "$EXTENSION is already installed. Enabling..."
    else
        echo "Downloading $EXTENSION from extensions.gnome.org..."
        extension_id=$(echo "$EXTENSION" | awk -F'@' '{print $1}')
        wget -O "/tmp/$extension_id.zip" "https://extensions.gnome.org/extension-data/$extension_id.shell-extension.zip"
        gnome-extensions install "/tmp/$extension_id.zip" || echo "Failed to install $EXTENSION"
    fi
    
    # Enable the extension
    gnome-extensions enable "$EXTENSION" || echo "Failed to enable $EXTENSION"
done

echo "GNOME Extensions installed and enabled!"


echo "Installing GNOME dependencies from the AUR..."

# Install GNOME dependencies and themes using yay
yay -S --needed --noconfirm \
    tweaks\
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


echo "Restarting GNOME Shell in 5 seconds..."
sleep 5
killall -3 gnome-shell

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


echo "Dotfiles and configurations applied successfully! 🎉"
