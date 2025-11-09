-- Some setups report it as <C-/>; map both
vim.keymap.set("n", "<C-_>", "<Plug>CommentaryLine", { silent = true })
vim.keymap.set("x", "<C-_>", "<Plug>Commentary", { silent = true })
vim.keymap.set("n", "<C-/>", "<Plug>CommentaryLine", { silent = true })
vim.keymap.set("x", "<C-/>", "<Plug>Commentary", { silent = true })
