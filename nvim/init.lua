-- Set leader early (safe even if duplicated in main)
vim.g.mapleader = "\\"

-- 1) Load plugins (bootstraps lazy.nvim + installs/loads onedark)
require("config.plugins")

-- 2) Core options, UI, keymaps, colorscheme, etc.
require("config.main")

-- 3) Plugin-specific configs
require("config.coc")
require("config.fzf")
require("config.gitgutter")
require("config.lightline")
require("config.nerdtree")
require("config.promptline")
require("config.tmuxline")
require("config.commentary")
