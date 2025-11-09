return {
  -- 💅 Colorscheme
  {
    "skatzteyp/onedark.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme onedark")
    end,
  },

  -- 💡 Statusline (Lightline)
  {
    "itchyny/lightline.vim",
    lazy = false,
    config = function()
      vim.g.lightline = {
        colorscheme = "onedark",
        component_function = {
          filename = "v:lua.LightlineFilename",
          mode = "v:lua.LightlineMode",
        },
      }

      function _G.LightlineFilename()
        local fname = vim.fn.expand("%:t")
        if fname:match("NvimTree") then
          return ""
        end
        return fname
      end

      function _G.LightlineMode()
        local fname = vim.fn.expand("%:t")
        if fname:match("NvimTree") then
          return "NvimTree"
        end
        return vim.fn["lightline#mode"]()
      end

      if vim.fn.exists("*lightline#enable") == 1 then
        vim.fn["lightline#enable"]()
      end
    end,
  },

  -- 📦 Tmux / Prompt integration
  { "edkolev/tmuxline.vim" },
  { "edkolev/promptline.vim" },

  -- 🪟 Transparency
  { "xiyaowong/nvim-transparent" },

  -- 📁 File explorer: nvim-tree + devicons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    priority = 50,
    config = function()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        api.config.mappings.default_on_attach(bufnr)

        -- NERDTree-ish muscle memory
        vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open: Edit File"))
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach,
        sort_by = "name",
        view = { width = 32, side = "left" },
        renderer = {
          root_folder_label = function(path)
            local full_path = vim.fn.fnamemodify(path, ":p")
            full_path = vim.fn.substitute(full_path, vim.fn.expand("$HOME"), "~", "")
            return " " .. full_path
          end,
          highlight_git = true,
          highlight_opened_files = "all",
          icons = {
            show = { file = true, folder = true, folder_arrow = true, git = true },
          },
        },
        update_focused_file = { enable = true, update_root = true },
        git = { enable = true },
        filters = { dotfiles = false },
      })

      vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { silent = true })
    end,
  },
}
