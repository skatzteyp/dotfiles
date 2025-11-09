#!/bin/sh
set -eu

# ============================================
#  Helpers
# ============================================

backup() {
  target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    ts=$(date +%Y%m%d%H%M%S)
    cp -r "$target" "${target}.bak.${ts}"
    printf "Backed up %s -> %s.bak.%s\n" "$target" "$target" "$ts"
  fi
}

link_file() {
  src="$1"
  dest="$2"

  # If source doesn't exist, skip silently (robust across setups)
  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    return
  fi

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
  printf "Linked %s -> %s\n" "$dest" "$src"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

headless_vim() {
  if have_cmd nvim; then
    nvim --headless "$@"
  elif have_cmd vim; then
    vim "$@"
  else
    return 1
  fi
}

# ============================================
#  Basic Git config
# ============================================

git config --global color.ui auto || true

GIT_NAME_CURRENT=$(git config --global user.name || true)
GIT_EMAIL_CURRENT=$(git config --global user.email || true)

if [ -t 0 ]; then
  printf "Git Name [%s]: " "${GIT_NAME_CURRENT}"
  read -r GIT_NAME_NEW || true
  [ -n "${GIT_NAME_NEW:-}" ] && git config --global user.name "$GIT_NAME_NEW"

  printf "Git Email [%s]: " "${GIT_EMAIL_CURRENT}"
  read -r GIT_EMAIL_NEW || true
  [ -n "${GIT_EMAIL_NEW:-}" ] && git config --global user.email "$GIT_EMAIL_NEW"

  printf "Update/Install plugins? [Y/n]: "
  read -r UPDATE_PLUGINS || UPDATE_PLUGINS="Y"
else
  UPDATE_PLUGINS="Y"
fi

# ============================================
#  Platform: macOS bootstrap (Homebrew, etc.)
# ============================================

OS="$(uname -s || echo "")"

if [ "$OS" = "Darwin" ]; then
  if ! have_cmd brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "Ensuring core packages (neovim, tmux, reattach-to-user-namespace, git, curl)..."
  brew install neovim tmux reattach-to-user-namespace git curl >/dev/null 2>&1 || true
else
  echo "Non-macOS detected ($OS). Skipping Homebrew auto-install."
  echo "Please ensure neovim/vim, tmux, git, and curl are installed."
fi

# ============================================
#  Paths
# ============================================

DOTFILES_DIR="$HOME/Projects/dotfiles"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_CONFIG_DIR="$XDG_CONFIG_HOME/nvim"
ALACRITTY_CONFIG_DIR="$XDG_CONFIG_HOME/alacritty"
ALACRITTY_THEMES_DIR="$ALACRITTY_CONFIG_DIR/themes"

mkdir -p "$XDG_CONFIG_HOME"

# ============================================
#  Clone or update dotfiles repo
# ============================================

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone https://github.com/skatzteyp/dotfiles.git "$DOTFILES_DIR"
else
  cd "$DOTFILES_DIR"
  git pull --ff-only
fi

cd "$DOTFILES_DIR"

# ============================================
#  vim-plug (for Vim/Neovim)
# ============================================

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Ensure ~/.vim exists
mkdir -p "$HOME/.vim"

# ============================================
#  Symlink Vim / Neovim configs
# ============================================

link_file "$DOTFILES_DIR/.vimrc"    "$HOME/.vimrc"
link_file "$DOTFILES_DIR/.vimrc.d"  "$HOME/.vimrc.d"
link_file "$HOME/.vim"              "$NVIM_CONFIG_DIR"
link_file "$HOME/.vimrc"            "$NVIM_CONFIG_DIR/init.vim"

# ============================================
#  Shell + tmux configs
# ============================================

link_file "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/.bashrc"       "$HOME/.bashrc"
link_file "$DOTFILES_DIR/.zsh_profile"  "$HOME/.zsh_profile"
link_file "$DOTFILES_DIR/.zshrc"        "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.shrc"         "$HOME/.shrc"
link_file "$DOTFILES_DIR/.tmux.conf"    "$HOME/.tmux.conf"

# ============================================
#  zsh-autosuggestions
# ============================================

if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
  echo "Installed zsh-autosuggestions."
fi

# ============================================
#  Alacritty config + theme
# ============================================

mkdir -p "$ALACRITTY_CONFIG_DIR"

# Link your Alacritty config (expects alacritty.toml in repo root)
if [ -f "$DOTFILES_DIR/alacritty.toml" ]; then
  link_file "$DOTFILES_DIR/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"
fi

# Install alacritty-theme (for imports in alacritty.toml)
if [ ! -d "$ALACRITTY_THEMES_DIR/.git" ]; then
  mkdir -p "$ALACRITTY_THEMES_DIR"
  # Clone directly into themes dir
  git clone https://github.com/alacritty/alacritty-theme.git "$ALACRITTY_THEMES_DIR"
  echo "Installed alacritty-theme into $ALACRITTY_THEMES_DIR."
fi

# ============================================
#  Nerd Font: DejaVu Sans Mono
# ============================================

NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DejaVuSansMono.zip"

if [ "$OS" = "Darwin" ]; then
  FONT_DIR="$HOME/Library/Fonts"
else
  FONT_DIR="$HOME/.local/share/fonts"
fi

mkdir -p "$FONT_DIR"

if ! ls "$FONT_DIR" | grep -qi "DejaVuSansMono.*Nerd"; then
  echo "Installing DejaVu Sans Mono Nerd Font..."
  TMP_FONT_ZIP="$(mktemp)"
  curl -fLo "$TMP_FONT_ZIP" "$NERD_FONT_URL"
  unzip -o "$TMP_FONT_ZIP" -d "$FONT_DIR" >/dev/null 2>&1 || true
  rm -f "$TMP_FONT_ZIP"
  if have_cmd fc-cache; then
    fc-cache -f "$FONT_DIR" || true
  fi
  echo "DejaVu Sans Mono Nerd Font installed (configure it in your terminal settings)."
fi

# ============================================
#  CoC global settings
# ============================================

if [ -f "$DOTFILES_DIR/coc-settings.json" ]; then
  mkdir -p "$NVIM_CONFIG_DIR"
  link_file "$DOTFILES_DIR/coc-settings.json" "$NVIM_CONFIG_DIR/coc-settings.json"
fi

# ============================================
#  Install / Update plugins
# ============================================

if [ "${UPDATE_PLUGINS:-Y}" != "n" ]; then
  if have_cmd nvim || have_cmd vim; then
    echo "Installing/updating plugins (headless)..."
    if ! headless_vim +PlugUpgrade +PlugClean! +PlugUpdate +qall; then
      echo "Plugin installation failed. You can retry manually with :PlugUpdate."
    fi
  else
    echo "No nvim/vim found. Skipping plugin installation."
  fi
fi

# ============================================
#  Promptline / Tmuxline snapshots
# ============================================

if [ -d "$HOME/.vim/plugged/promptline.vim" ]; then
  headless_vim +"PromptlineSnapshot! ~/.promptline.sh" +qall || true
fi

if [ -d "$HOME/.vim/plugged/tmuxline.vim" ]; then
  headless_vim +Tmuxline +"TmuxlineSnapshot! ~/.tmuxline.conf" +qall || true
fi

# ============================================
#  Done
# ============================================

echo
echo "Dotfiles installation complete."
echo "Open Alacritty (with DejaVu Sans Mono Nerd Font) to start tmux + Neovim."
