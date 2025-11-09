-- Tell lightline to use our Lua-backed functions via v:lua
vim.g.lightline = {
  colorscheme = "onedark",
  component_function = {
    filename = "v:lua.LightlineFilename",
    mode = "v:lua.LightlineMode",
  },
}

-- Filename component
function _G.LightlineFilename()
  local fname = vim.fn.expand("%:t")
  if fname:match("NERD_tree") then
    return ""
  end
  return fname
end

-- Mode component
function _G.LightlineMode()
  local fname = vim.fn.expand("%:t")
  if fname:match("NERD_tree") then
    return "NERDTree"
  end
  return vim.fn["lightline#mode"]()
end
