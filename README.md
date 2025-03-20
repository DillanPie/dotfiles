# 🌌 My Dotfiles
![GitHub repo size](https://img.shields.io/github/repo-size/DillanPie/dotfiles)
![GitHub last commit](https://img.shields.io/github/last-commit/DillanPie/dotfiles)
![GitHub stars](https://img.shields.io/github/stars/DillanPie/dotfiles?style=social)
![GitHub forks](https://img.shields.io/github/forks/DillanPie/dotfiles?style=social)

A fully automated setup for my **Arch Linux system**, including:

- 🖥️ **GNOME Desktop Environment** (Full installation with login manager)
- 🐚 **Oh-My-Zsh** (Theme management)
- 🎵 **Spicetify** (Spotify theming)
- 📦 **Spotify Installation** via `yay`
- ⚡ **Fastfetch** (Terminal customization)
- 🔒 **Automatic SSH Setup for GitHub**
- 🔌 **GNOME Extensions from repo (auto-enabled)**

---

## 📂 What's Included

### 🔧 **GNOME Configuration**
- Full **GNOME Desktop Environment** (`gnome`, `gnome-extra`, `gdm`)
- Cursor Theme: `Bibata-Modern-Ice`
- Icon Theme: `Papirus-Dark`
- Shell Theme: `Gruvbox-Dark`
- Applications Theme: `Gruvbox-Material-Dark`
- Font: `FiraCode Nerd Font`
- Wallpaper: `wallpaper.png` (Automatically applied)
- GNOME Extensions (auto-enabled)

### 🐚 **Oh-My-Zsh**
- Custom theme installed to `~/.oh-my-zsh/custom/themes/`

### 🎵 **Spicetify**
- Themes copied to `~/.config/spicetify/Themes/`
- Automatically applied with your preferred theme

### 📦 **yay (AUR Helper)**
- Automatic installation if not detected

### 🎧 **Spotify Installation**
- Spotify installed via `yay`

### ⚡ **Fastfetch**
- Configuration copied to `~/.config/fastfetch/`

---

## 🚀 Installation (Fresh Arch Install)
This script will fully set up your system from a fresh Arch install.

### 📥 **One-Liner Installation (Recommended)**
```bash
bash <(curl -s https://raw.githubusercontent.com/DillanPie/dotfiles/main/bootstrap.sh)
