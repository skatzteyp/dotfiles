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
    printf "📦 Backed up %s → %s.bak.%s\n" "$target" "$target" "$ts"
  fi
}

link_file() {
  src="$1"
  dest="$2"

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    # Silent skip if source does not exist; keeps script robust across setups
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
  printf "🔗 Linked %s → %s\n" "$dest" "$src"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# Pick an editor command for headless tasks
headless_vim() {
  if have_cmd nvim; then
    nvim "$@"
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
#  Detect platform & ensure dependencies
# ============================================

OS="$(uname -s || echo "")"

if [ "$OS" = "Darwin" ]; then
  # ---- Homebrew ----
  if ! have_cmd brew; then
    printf "🍺 Installing Homebrew...\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # ---- Core packages ----
  printf "📦 Ensuring core packages (neovim, tmux, reattach-to-user-namespace, git, curl)...\n"
  brew install neovim tmux reattach-to-user-namespace git curl >/dev/null 2>&1 || true

else
  printf "ℹ️ Non-macOS detected (%s). Skipping Homebrew auto-install.\n" "$OS"
  printf "   Please ensure neovim/vim, tmux, git, and curl are installed.\n"
fi

# ============================================
#  Paths
# ============================================

DOTFILES_DIR="$HOME/Projects/dotfiles"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_CONFIG_DIR="$XDG_CONFIG_HOME/nvim"
ALACRITTY_CONFIG_DIR="$XDG_CONFIG_HOME/alacritty"

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
#  Vim / Neovim bootstrap
# ============================================

# Install vim-plug for Vim (Neovim will also use it via init.vim)
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  printf "📥 Installing vim-plug...\n"
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

# Symlink vim / nvim configs
link_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/.vimrc.d" "$HOME/.vimrc.d"

# Ensure ~/.vim exists (vim-plug curl usually created it)
mkdir -p "$HOME/.vim"

# Neovim uses Vim config via symlinks
link_file "$HOME/.vim" "$NVIM_CONFIG_DIR"
link_file "$HOME/.vimrc" "$NVIM_CONFIG_DIR/init.vim"

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
  printf "✅ Installed zsh-autosuggestions\n"
fi

# ============================================
#  Alacritty
# ============================================

mkdir -p "$ALACRITTY_CONFIG_DIR"

if [ -f "$DOTFILES_DIR/alacritty.toml" ]; then
  link_file "$DOTFILES_DIR/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"
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
    printf "🔄 Installing / updating plugins (headless)...\n"
    headless_vim +PlugUpgrade +PlugClean! +PlugUpdate +qall || \
      printf "⚠️ Plugin installation failed. You can retry manually inside Vim/Neovim.\n"
  else
    printf "⚠️ Neither nvim nor vim found. Skipping plugin installation.\n"
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

printf "\n🎉 Dotfiles installation complete.\n"
printf "➡️  Recommended: use Alacritty as your terminal.\n"
printf "   It will start tmux automatically and load your Neovim-based setup.\n"
