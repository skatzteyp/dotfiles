-- Promptline theme to match onedark-ish setup
vim.g.promptline_theme = {
  a    = { 0, 4 },
  b    = { 253, 239 },
  c    = { 244, 0 },
  x    = { 244, 0 },
  y    = { 253, 239 },
  z    = { 0, 4 },
  warn = { 232, 166 },
}

-- Promptline preset
vim.g.promptline_preset = {
  a    = { vim.fn["promptline#slices#user"]() },
  b    = { vim.fn["promptline#slices#cwd"]() },
  y    = { vim.fn["promptline#slices#git_status"]() },
  z    = { vim.fn["promptline#slices#vcs_branch"]() },
  warn = {
    vim.fn["promptline#slices#last_exit_code"](),
    vim.fn["promptline#slices#jobs"](),
  },
}

-- Disable powerline symbols
vim.g.promptline_powerline_symbols = 0
