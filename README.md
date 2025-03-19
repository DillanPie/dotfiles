# 🌌 My Dotfiles
![GitHub repo size](https://img.shields.io/github/repo-size/DillanPie/dotfiles)
![GitHub last commit](https://img.shields.io/github/last-commit/DillanPie/dotfiles)
![GitHub stars](https://img.shields.io/github/stars/DillanPie/dotfiles?style=social)
![GitHub forks](https://img.shields.io/github/forks/DillanPie/dotfiles?style=social)

A fully automated setup for my **Arch Linux system**, including:

- 🖥️ **GNOME Configuration** (Themes, Icons, Cursors, Fonts, Wallpaper)
- 🐚 **Oh-My-Zsh** (Theme management)
- 🎵 **Spicetify** (Spotify theming)
- ⚡ **Fastfetch** (Terminal customization)
- 📦 **yay** (AUR Helper for automated package installation)
- 🔒 **Automatic SSH Setup for GitHub**

---

## 📂 What's Included

### 🔧 **GNOME Configuration**
- Cursor Theme: `Bibata-Modern-Ice`
- Icon Theme: `Papirus-Dark`
- Shell Theme: `Gruvbox-Dark`
- Applications Theme: `Gruvbox-Material-Dark`
- Font: `FiraCode Nerd Font`
- Wallpaper: `wallpaper.png` (Automatically applied)

### 🐚 **Oh-My-Zsh**
- Custom theme installed to `~/.oh-my-zsh/custom/themes/`

### 🎵 **Spicetify**
- Themes copied to `~/.config/spicetify/Themes/`
- Automatically applied with your preferred theme

### ⚡ **Fastfetch**
- Configuration copied to `~/.config/fastfetch/`

### 📦 **yay (AUR Helper)**
- Automatic installation if not detected

---

## 🚀 Installation (Fresh Arch Install)

If you just installed Arch Linux and want to get your full setup working in one command:

```bash
bash <(curl -s https://raw.githubusercontent.com/DillanPie/dotfiles/main/bootstrap.sh)
