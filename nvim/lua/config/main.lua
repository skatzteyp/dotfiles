-- === Leader ===
vim.g.mapleader = "\\"

-- === Colors / Truecolor ===
pcall(vim.cmd.colorscheme, "onedark")

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- === UI ===
vim.opt.number = true              -- line numbers
vim.opt.relativenumber = true      -- relative numbers
vim.opt.scrolloff = 4              -- keep context lines
vim.opt.showmatch = true           -- highlight matching bracket
vim.opt.showmode = false           -- statusline handles mode
vim.opt.mouse = "a"                -- mouse support
vim.opt.swapfile = false           -- no swapfiles

-- Whitespace
vim.opt.list = true
vim.opt.listchars = {
  tab = "› ",
  trail = "-",
  extends = ">",
  precedes = "<",
  eol = "¬",
}

-- === Indent / Tabs ===
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.backspace = { "indent", "eol", "start" }

-- === Clipboard ===
if vim.fn.has("clipboard") == 1 then
  vim.opt.clipboard = { "unnamed", "unnamedplus" }
end

-- === Window navigation ===
local map = vim.keymap.set
local opts = { silent = true }

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- === Visual shifting ===
map("v", "<S-Tab>", "<gv", opts)
map("v", "<Tab>", ">gv", opts)

-- === Transparent background (for nvim-transparent) ===
vim.g.transparent_enabled = true

-- === Disable all bells ===
vim.opt.errorbells = false
vim.opt.visualbell = false

if vim.fn.exists("&t_vb") == 1 then
  vim.opt.t_vb = ""
end

if vim.fn.exists("&belloff") == 1 then
  vim.opt.belloff = "all"
end
