#!/bin/sh
set -eu

########################################
# Helpers
########################################

backup() {
  target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    ts=$(date +%Y%m%d%H%M%S)
    cp -r "$target" "${target}.bak.${ts}"
    printf "📦 Backed up %s -> %s.bak.%s\n" "$target" "$target" "$ts"
  fi
}

link_file() {
  src="$1"
  dest="$2"

  [ ! -e "$src" ] && [ ! -L "$src" ] && return

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest" || true)" = "$src" ]; then
      return
    fi
    rm -f "$dest"
  elif [ -e "$dest" ]; then
    backup "$dest"
    rm -rf "$dest"
  fi

  ln -s "$src" "$dest"
  printf "🔗 Linked %s -> %s\n" "$dest" "$src"
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

headless_vim() {
  if have_cmd nvim; then
    nvim --headless "$@"
  elif have_cmd vim; then
    vim "$@"
  fi
}

########################################
# Git config
########################################

git config --global color.ui auto || true

if [ -t 0 ]; then
  GIT_NAME=$(git config --global user.name || true)
  GIT_EMAIL=$(git config --global user.email || true)

  printf "Git Name [%s]: " "$GIT_NAME"
  read -r NEW_NAME || true
  [ -n "${NEW_NAME:-}" ] && git config --global user.name "$NEW_NAME"

  printf "Git Email [%s]: " "$GIT_EMAIL"
  read -r NEW_EMAIL || true
  [ -n "${NEW_EMAIL:-}" ] && git config --global user.email "$NEW_EMAIL"

  printf "Update/Install plugins? [Y/n]: "
  read -r UPDATE_PLUGINS || UPDATE_PLUGINS="Y"
else
  UPDATE_PLUGINS="Y"
fi

########################################
# OS / WSL detection
########################################

OS="$(uname -s || echo "")"
IS_MAC=false
IS_LINUX=false
IS_WSL=false

case "$OS" in
  Darwin*) IS_MAC=true ;;
  Linux*)  IS_LINUX=true ;;
esac

if $IS_LINUX && grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
  echo "🪟 Detected WSL (Windows Subsystem for Linux)"
fi

########################################
# Base packages
########################################

if $IS_MAC; then
  if ! have_cmd brew; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "📦 Ensuring neovim, tmux, git, curl, unzip..."
  brew install neovim tmux reattach-to-user-namespace git curl unzip >/dev/null 2>&1 || true

elif $IS_LINUX; then
  echo "🐧 Ensuring neovim, tmux, git, curl, unzip..."
  if have_cmd apt-get; then
    sudo apt-get update -y
    sudo apt-get install -y neovim tmux git curl unzip
  fi
else
  echo "ℹ️ Unknown OS ($OS). Please ensure neovim/vim, tmux, git, curl, unzip are installed."
fi

########################################
# Paths
########################################

DOTFILES_DIR="$HOME/Projects/dotfiles"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_CONFIG_DIR="$XDG_CONFIG_HOME/nvim"
ALACRITTY_CONFIG_DIR="$XDG_CONFIG_HOME/alacritty"
ALACRITTY_THEMES_DIR="$ALACRITTY_CONFIG_DIR/themes"

mkdir -p "$XDG_CONFIG_HOME"

########################################
# Clone / update dotfiles repo
########################################

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone https://github.com/skatzteyp/dotfiles.git "$DOTFILES_DIR"
else
  cd "$DOTFILES_DIR"
  git pull --ff-only
fi

cd "$DOTFILES_DIR"

########################################
# vim-plug
########################################

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  echo "📥 Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

mkdir -p "$HOME/.vim"

########################################
# Symlinks (shell, vim, tmux)
########################################

link_file "$DOTFILES_DIR/.vimrc"           "$HOME/.vimrc"
link_file "$DOTFILES_DIR/.vimrc.d"         "$HOME/.vimrc.d"
link_file "$HOME/.vim"                     "$NVIM_CONFIG_DIR"
link_file "$HOME/.vimrc"                   "$NVIM_CONFIG_DIR/init.vim"

link_file "$DOTFILES_DIR/.bash_profile"    "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/.bashrc"          "$HOME/.bashrc"
link_file "$DOTFILES_DIR/.zsh_profile"     "$HOME/.zsh_profile"
link_file "$DOTFILES_DIR/.zshrc"           "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.shrc"            "$HOME/.shrc"
link_file "$DOTFILES_DIR/.tmux.conf"       "$HOME/.tmux.conf"

########################################
# zsh-autosuggestions
########################################

if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi

########################################
# Alacritty + theme (only for non-WSL)
########################################

if $IS_MAC || ( $IS_LINUX && ! $IS_WSL ); then
  mkdir -p "$ALACRITTY_CONFIG_DIR"

  if [ -f "$DOTFILES_DIR/alacritty.toml" ]; then
    link_file "$DOTFILES_DIR/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"
  fi

  if [ ! -d "$ALACRITTY_THEMES_DIR/.git" ]; then
    git clone https://github.com/alacritty/alacritty-theme.git "$ALACRITTY_THEMES_DIR"
  fi
else
  echo "ℹ️ WSL detected: skipping Alacritty config (use Windows Terminal on host)."
fi

########################################
# Nerd Font (only where it makes sense)
########################################

NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DejaVuSansMono.zip"

if $IS_MAC; then
  FONT_DIR="$HOME/Library/Fonts"
elif $IS_LINUX && ! $IS_WSL; then
  FONT_DIR="$HOME/.local/share/fonts"
else
  FONT_DIR=""
fi

if [ -n "$FONT_DIR" ]; then
  mkdir -p "$FONT_DIR"
  if ! ls "$FONT_DIR" 2>/dev/null | grep -qi "DejaVuSansMono.*Nerd"; then
    echo "🔤 Installing DejaVu Sans Mono Nerd Font..."
    TMP_FONT_ZIP="$(mktemp)"
    curl -fLo "$TMP_FONT_ZIP" "$NERD_FONT_URL"
    unzip -o "$TMP_FONT_ZIP" -d "$FONT_DIR" >/dev/null 2>&1 || true
    rm -f "$TMP_FONT_ZIP"
    have_cmd fc-cache && fc-cache -f "$FONT_DIR" || true
  fi
elif $IS_WSL; then
  echo "ℹ️ WSL: install 'DejaVuSansMono Nerd Font' on Windows and select it in Windows Terminal."
fi

########################################
# nvm + Node 22 + Yarn + pnpm
########################################

if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" || true

if have_cmd nvm; then
  echo "⬇️ Installing Node.js v22..."
  nvm install 22 >/dev/null 2>&1 || true
  nvm alias default 22 >/dev/null 2>&1 || true
  nvm use default >/dev/null 2>&1 || true
  echo "✅ Using Node: $(node -v 2>/dev/null || echo 'not available')"
else
  echo "⚠️ nvm not available in this shell. Open a new shell and run this script again if needed."
fi

if have_cmd npm; then
  echo "📦 Installing Yarn & pnpm globally..."
  npm install -g yarn pnpm >/dev/null 2>&1 || true
fi

########################################
# CoC settings
########################################

if [ -f "$DOTFILES_DIR/coc-settings.json" ]; then
  mkdir -p "$NVIM_CONFIG_DIR"
  link_file "$DOTFILES_DIR/coc-settings.json" "$NVIM_CONFIG_DIR/coc-settings.json"
fi

########################################
# Plugins (vim-plug)
########################################

if [ "${UPDATE_PLUGINS:-Y}" != "n" ] && ( have_cmd nvim || have_cmd vim ); then
  echo "🔄 Installing / updating plugins (headless)..."
  headless_vim +PlugUpgrade +PlugClean! +PlugUpdate +qall || true
fi

########################################
# Promptline / Tmuxline snapshots
########################################

if [ -d "$HOME/.vim/plugged/promptline.vim" ]; then
  headless_vim +"PromptlineSnapshot! ~/.promptline.sh" +qall || true
fi

if [ -d "$HOME/.vim/plugged/tmuxline.vim" ]; then
  headless_vim +Tmuxline +"TmuxlineSnapshot! ~/.tmuxline.conf" +qall || true
fi

########################################
# Done
########################################

echo
echo "🎉 Setup complete!"
echo "   - Shell, tmux, Neovim configured"
echo "   - Node: $(node -v 2>/dev/null || echo 'not detected')"
echo "   - Yarn: $(yarn -v 2>/dev/null || echo 'not detected')"
echo "   - pnpm: $(pnpm -v 2>/dev/null || echo 'not detected')"
echo "   - On WSL: set Nerd Font in Windows Terminal; no Alacritty needed."
