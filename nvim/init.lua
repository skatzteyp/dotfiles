-- Set leader early (safe even if duplicated in main)
vim.g.mapleader = "\\"

require("config.plugins")  -- lazy + plugin specs
require("config.main")     -- options, ui, keymaps
require("config.coc")      -- coc behavior
require("config.fzf")
require("config.gitgutter")
require("config.promptline")
require("config.tmuxline")
require("config.commentary")
