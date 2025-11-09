-- FZF colors
vim.g.fzf_colors = {
  fg      = { "fg", "Normal" },
  bg      = { "bg", "Normal" },
  hl      = { "fg", "IncSearch" },
  ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
  ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
  ["hl+"] = { "fg", "IncSearch" },
  info    = { "fg", "IncSearch" },
  border  = { "fg", "Ignore" },
  prompt  = { "fg", "Comment" },
  pointer = { "fg", "IncSearch" },
  marker  = { "fg", "IncSearch" },
  spinner = { "fg", "IncSearch" },
  header  = { "fg", "WildMenu" },
}

-- FZF layout
vim.g.fzf_layout = {
  window = {
    width = 0.8,
    height = 0.5,
    highlight = "Comment",
  },
}

-- <leader>p -> git files
vim.keymap.set("n", "<leader>p", ":GFiles<CR>", { silent = true })
