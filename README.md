# 🧰 My Dotfiles

Personal dotfiles for **Alacritty**, **tmux**, **Neovim**, and **zsh** — built for modern web development with **Next.js**, **React**, and **PHP**.  
Unified **OneDark** theme, **CoC LSP** support, and smooth terminal → tmux → Neovim integration.

---

## ⚙️ Quick Install

Run:

sh <(curl -sL https://raw.githubusercontent.com/skatzteyp/dotfiles/main/install.sh)

This will:

- Install **Homebrew**, **Neovim**, **tmux**, and dependencies (on macOS)
- Clone/update this repo to `~/Projects/dotfiles`
- Create timestamped backups of existing configs
- Symlink configs for shell, Neovim/Vim, tmux, and Alacritty
- Install **vim-plug**, **zsh-autosuggestions**, and all plugins (headless)
- Generate **promptline** and **tmuxline** configs

---

## 🧩 Highlights

- Neovim/Vim IDE setup with **CoC** for TS/JS/React/CSS/HTML/JSON/PHP
- **FZF** fuzzy finder + **NERDTree** file explorer
- **Prettier + ESLint** integration (format on save ready)
- **OneDark** theme across terminal, tmux, and Neovim
- Transparent terminal/Neovim support
- **zsh-autosuggestions** + shared aliases via `.shrc`
- Safe, re-runnable installer using symlinks

---

## 💡 Common Mappings

- `<leader>n` — toggle NERDTree
- `<leader>p` — FZF Git files
- `Ctrl-h/j/k/l` — move between splits
- `Ctrl-/` (or `Ctrl-_`) — comment with vim-commentary

---

Open **Alacritty** → tmux starts → Neovim ready → start coding 🚀
