return {
  -- 📦 Core / QoL
  { "editorconfig/editorconfig-vim" },
  { "terryma/vim-multiple-cursors" },
  { "airblade/vim-gitgutter" },

  -- 🧠 LSP / IntelliSense (CoC)
  {
    "neoclide/coc.nvim",
    branch = "release",
    -- keymaps & behavior are in lua/config/coc.lua
  },

  -- 🧹 Text objects / commenting
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  { "wellle/targets.vim" },

  -- 🔍 Fuzzy finder
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  { "junegunn/fzf.vim" },

  -- 🚀 Navigation
  { "ThePrimeagen/harpoon" },

  -- 🧪 Testing
  { "vim-test/vim-test" },
  { "tpope/vim-dispatch" },

  -- 🤖 AI Assistant
  { "github/copilot.vim" },
}
