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

# Install extensions via extension manager if available
if command -v gnome-extensions &> /dev/null; then
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

    # Install extensions
    for EXTENSION in "${EXTENSIONS_LIST[@]}"; do
        echo "Checking if $EXTENSION is installed..."
        if gnome-extensions list | grep -q "$EXTENSION"; then
            echo "$EXTENSION is already installed. Enabling..."
        else
            echo "Installing $EXTENSION..."
            gnome-extensions install "$EXTENSION" || echo "Failed to install $EXTENSION"
        fi
        
        # Enable extensions
        gnome-extensions enable "$EXTENSION" || echo "Failed to enable $EXTENSION"
    done
else
    echo "gnome-extensions command not found. Make sure GNOME Shell Extensions are installed."
fi

echo "Installing GNOME dependencies from the AUR..."

# Install GNOME dependencies and themes using yay
yay -S --needed --noconfirm \
    papirus-icon-theme \
    gruvbox-gtk-theme \
    bibata-cursor-theme \
    ttf-firacode-nerd \
    gnome-shell-extension-manager

# Ensure required directories exist
mkdir -p ~/.themes ~/.icons ~/.local/share/fonts

echo "Setting up GNOME themes, icons, fonts, and cursors..."

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

# Restart GNOME Shell for changes to take effect
echo "Restarting GNOME Shell..."
gnome-session-quit --reboot

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

echo "Dotfiles and configurations applied successfully! 🎉"
