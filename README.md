# My Dotfiles

Personal dotfiles for **Alacritty**, **tmux**, **Neovim**, and **zsh** — built for modern web development with **Next.js**, **React**, and **PHP**.  
Unified **OneDark** theme, **CoC LSP** support, and smooth terminal → tmux → Neovim integration.

---

## Quick Install

Run:

```
sh <(curl -sL https://raw.githubusercontent.com/skatzteyp/dotfiles/main/install.sh)
```

This will:

- Install **Homebrew**, **Neovim**, **tmux**, and dependencies (on macOS)
- Clone/update this repo to `~/Projects/dotfiles`
- Create timestamped backups of existing configs
- Symlink configs for shell, Neovim, tmux, and Alacritty
- Install **lazy.nvim**, **zsh-autosuggestions**, and all plugins (headless)
- Generate **promptline** and **tmuxline** configs

> Note: the plugin step runs `:Lazy sync`, which both installs declared plugins
> and **removes any plugin not in the spec**. Re-running the installer will wipe
> ad-hoc plugins added with `:Lazy install` outside this repo. Answer `n` at the
> "Sync plugins?" prompt to skip.

---

## Highlights

- Neovim IDE setup with **CoC** for TS/JS/React/CSS/HTML/JSON/PHP
- **FZF** fuzzy finder + **nvim-tree** file explorer
- **Prettier + ESLint** integration (format on save ready)
- **OneDark** theme across terminal, tmux, and Neovim
- Transparent terminal/Neovim support
- **zsh-autosuggestions** + shared aliases via `.shrc`
- Safe, re-runnable installer using symlinks

---

## Common Mappings

Leader is `\`.

### Navigation / files

- `<leader>n` — toggle nvim-tree
- `<leader>p` — FZF Git files
- `Ctrl-h/j/k/l` — move between splits
- `Ctrl-/` (or `Ctrl-_`) — comment with vim-commentary

### CoC (LSP)

- `gd` / `gy` / `gi` / `gr` — go to definition / type / implementation / references
- `K` — hover documentation
- `[g` / `]g` — previous / next diagnostic
- `<leader>rn` — rename symbol
- `<leader>f` — format selection
- `<leader>a` — code action on selection
- `<leader>ac` — code action at cursor
- `<leader>qf` — quick fix at cursor
- `<space>a` / `<space>e` / `<space>c` / `<space>o` / `<space>s` — diagnostics / extensions / commands / outline / symbols list

### Claude Code (`coder/claudecode.nvim`)

- `<leader>cc` — toggle Claude
- `<leader>cf` — focus Claude
- `<leader>cr` — resume previous session
- `<leader>cC` — continue last conversation
- `<leader>cm` — select model
- `<leader>cb` — add current buffer to Claude
- `<leader>cs` — send selection (visual) / add tree file (normal)
- `<leader>ca` / `<leader>cd` — accept / deny diff

---
