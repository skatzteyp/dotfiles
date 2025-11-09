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
    printf "📦 Backed up %s -> %s.bak.%s\n" "$target" "$target" "$ts"
  fi
}

link_file() {
  src="$1"
  dest="$2"
  [ ! -e "$src" ] && [ ! -L "$src" ] && return
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    [ "$(readlink "$dest" || true)" = "$src" ] && return
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
  if have_cmd nvim; then nvim --headless "$@"
  elif have_cmd vim; then vim "$@"
  fi
}

# ============================================
#  Git Config
# ============================================

git config --global color.ui auto || true
if [ -t 0 ]; then
  GIT_NAME=$(git config --global user.name || true)
  GIT_EMAIL=$(git config --global user.email || true)
  printf "Git Name [%s]: " "$GIT_NAME"; read -r NEW_NAME || true
  [ -n "${NEW_NAME:-}" ] && git config --global user.name "$NEW_NAME"
  printf "Git Email [%s]: " "$GIT_EMAIL"; read -r NEW_EMAIL || true
  [ -n "${NEW_EMAIL:-}" ] && git config --global user.email "$NEW_EMAIL"
fi

# ============================================
#  OS Detection
# ============================================

OS="$(uname -s || echo "")"
IS_MAC=false
IS_LINUX=false

case "$OS" in
  Darwin*) IS_MAC=true ;;
  Linux*)  IS_LINUX=true ;;
esac

# ============================================
#  macOS Core Tools
# ============================================

if $IS_MAC; then
  if ! have_cmd brew; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "📦 Ensuring neovim, tmux, git, curl..."
  brew install neovim tmux reattach-to-user-namespace git curl >/dev/null 2>&1 || true
elif $IS_LINUX; then
  echo "🐧 Ensuring neovim, tmux, git, curl..."
  if have_cmd apt-get; then
    sudo apt-get update -y
    sudo apt-get install -y neovim tmux git curl unzip
  fi
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
#  Clone or Update Dotfiles Repo
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
#  vim-plug
# ============================================

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  echo "📥 Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# ============================================
#  Symlinks
# ============================================

link_file "$DOTFILES_DIR/.vimrc"    "$HOME/.vimrc"
link_file "$DOTFILES_DIR/.vimrc.d"  "$HOME/.vimrc.d"
link_file "$HOME/.vim"              "$NVIM_CONFIG_DIR"
link_file "$HOME/.vimrc"            "$NVIM_CONFIG_DIR/init.vim"
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
fi

# ============================================
#  Alacritty Theme & Config
# ============================================

mkdir -p "$ALACRITTY_CONFIG_DIR"
if [ -f "$DOTFILES_DIR/alacritty.toml" ]; then
  link_file "$DOTFILES_DIR/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"
fi
if [ ! -d "$ALACRITTY_THEMES_DIR/.git" ]; then
  git clone https://github.com/alacritty/alacritty-theme.git "$ALACRITTY_THEMES_DIR"
fi

# ============================================
#  Nerd Font
# ============================================

NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DejaVuSansMono.zip"
FONT_DIR="$HOME/.local/share/fonts"
$IS_MAC && FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"
if ! ls "$FONT_DIR" | grep -qi "DejaVuSansMono.*Nerd"; then
  echo "🔤 Installing DejaVu Sans Mono Nerd Font..."
  TMP_FONT_ZIP="$(mktemp)"
  curl -fLo "$TMP_FONT_ZIP" "$NERD_FONT_URL"
  unzip -o "$TMP_FONT_ZIP" -d "$FONT_DIR" >/dev/null 2>&1 || true
  rm -f "$TMP_FONT_ZIP"
  have_cmd fc-cache && fc-cache -f "$FONT_DIR" || true
fi

# ============================================
#  nvm + Node + Yarn + pnpm
# ============================================

if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if have_cmd nvm; then
  echo "⬇️ Installing Node.js v22..."
  nvm install 22
  nvm alias default 22
  nvm use default
  echo "✅ Node $(node -v) installed."
else
  echo "⚠️ nvm not loaded. Restart your shell and re-run install.sh."
fi

# Install yarn & pnpm globally
if have_cmd npm; then
  echo "📦 Installing Yarn & pnpm..."
  npm install -g yarn pnpm >/dev/null 2>&1 || true
fi

# ============================================
#  CoC Settings
# ============================================

if [ -f "$DOTFILES_DIR/coc-settings.json" ]; then
  mkdir -p "$NVIM_CONFIG_DIR"
  link_file "$DOTFILES_DIR/coc-settings.json" "$NVIM_CONFIG_DIR/coc-settings.json"
fi

# ============================================
#  Plugin Install
# ============================================

if have_cmd nvim || have_cmd vim; then
  echo "🔄 Installing / updating plugins (headless)..."
  headless_vim +PlugUpgrade +PlugClean! +PlugUpdate +qall || true
fi

# ============================================
#  Promptline / Tmuxline
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
echo "🎉 Setup complete!"
echo "➡️  Alacritty + tmux + Neovim ready"
echo "   Node $(node -v), Yarn $(yarn -v), pnpm $(pnpm -v)"
