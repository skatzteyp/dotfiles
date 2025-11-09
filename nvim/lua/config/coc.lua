-- === CoC Extensions ===
vim.g.coc_global_extensions = {
  "coc-tsserver",
  "coc-css",
  "coc-html",
  "coc-styled-components",
  "coc-json",
  "coc-eslint",
  "coc-prettier",
  "coc-tailwindcss",
  "coc-emmet",
  "coc-prisma",
}

-- === Core settings for CoC ===
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- === Helper: CheckBackspace (for <Tab>) ===
local function check_backspace()
  local col = vim.fn.col(".") - 1
  if col == 0 then
    return true
  end
  local line = vim.fn.getline(".")
  return line:sub(col, col):match("%s") ~= nil
end

local expr_opts = { silent = true, noremap = true, expr = true }

-- === Tab completion ===
vim.keymap.set("i", "<Tab>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn
  elseif check_backspace() then
    return "\t"
  else
    vim.fn["coc#refresh"]()
    return ""
  end
end, vim.tbl_extend("force", expr_opts, { replace_keycodes = false }))

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn
  else
    return vim.api.nvim_replace_termcodes("<C-h>", true, false, true)
  end
end, expr_opts)

vim.keymap.set("i", "<CR>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn["coc#pum#confirm"]()
  end
  -- fallback to original behavior with coc#on_enter
  return vim.api.nvim_replace_termcodes(
    "<C-g>u<CR><C-r>=coc#on_enter()<CR>",
    true,
    false,
    true
  )
end, expr_opts)

-- Trigger completion
vim.keymap.set("i", "<C-Space>", "coc#refresh()", expr_opts)

-- === Diagnostics ===
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- === Go-to ===
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

-- === Hover (guarded) ===
local function show_documentation()
  if vim.fn.exists("*CocAction") == 1 and vim.fn.CocAction("hasProvider", "hover") == 1 then
    vim.fn.CocActionAsync("doHover")
  else
    vim.cmd("normal! K")
  end
end

vim.keymap.set("n", "K", show_documentation, { silent = true })

-- === Highlight references on CursorHold ===
local hl_group = vim.api.nvim_create_augroup("CocHighlight", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = hl_group,
  callback = function()
    if vim.fn.exists("*CocActionAsync") == 1 then
      vim.fn.CocActionAsync("highlight")
    end
  end,
})

-- === Rename / Format / Code actions ===
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", {})
vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", {})

vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", {})
vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", {})

vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)", {})
vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", {})
vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", {})

-- Function / class text objects
vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", {})
vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", {})
vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", {})
vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", {})
vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", {})
vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", {})
vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", {})
vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", {})

-- === Float windows scroll ===
if vim.fn.has("nvim-0.4.0") == 1 or vim.fn.has("patch-8.2.0750") == 1 then
  local float_expr = { silent = true, nowait = true, noremap = true, expr = true }

  vim.keymap.set("n", "<C-f>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn
    else
      return vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
    end
  end, float_expr)

  vim.keymap.set("n", "<C-b>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn
    else
      return vim.api.nvim_replace_termcodes("<C-b>", true, false, true)
    end
  end, float_expr)

  vim.keymap.set("x", "<C-f>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn
    else
      return vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
    end
  end, float_expr)

  vim.keymap.set("x", "<C-b>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn
    else
      return vim.api.nvim_replace_termcodes("<C-b>", true, false, true)
    end
  end, float_expr)

  vim.keymap.set("i", "<C-f>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.api.nvim_replace_termcodes("<C-r>=coc#float#scroll(1)<CR>", true, false, true)
    else
      return vim.api.nvim_replace_termcodes("<Right>", true, false, true)
    end
  end, float_expr)

  vim.keymap.set("i", "<C-b>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.api.nvim_replace_termcodes("<C-r>=coc#float#scroll(0)<CR>", true, false, true)
    else
      return vim.api.nvim_replace_termcodes("<Left>", true, false, true)
    end
  end, float_expr)
end

-- === Range select ===
vim.keymap.set("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
vim.keymap.set("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- === Commands ===
vim.api.nvim_create_user_command("Format", function()
  vim.fn.CocActionAsync("format")
end, {})

vim.api.nvim_create_user_command("Fold", function()
  vim.fn.CocAction("fold")
end, {})

vim.api.nvim_create_user_command("OR", function()
  vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")
end, {})

-- Only patch statusline if Lightline is NOT present
if vim.g.lightline == nil then
  local existing = vim.opt.statusline:get()
  vim.opt.statusline =
    "%{get(g:,'coc_status','')}%{get(b:,'coc_current_function','')}" .. existing
end

-- === CoCList mappings ===
local coclist_opts = { silent = true, nowait = true }
vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<CR>", coclist_opts)
vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<CR>", coclist_opts)
vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<CR>", coclist_opts)
vim.keymap.set("n", "<space>o", ":<C-u>CocList outline<CR>", coclist_opts)
vim.keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<CR>", coclist_opts)
vim.keymap.set("n", "<space>j", ":<C-u>CocNext<CR>", coclist_opts)
vim.keymap.set("n", "<space>k", ":<C-u>CocPrev<CR>", coclist_opts)
vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<CR>", coclist_opts)
