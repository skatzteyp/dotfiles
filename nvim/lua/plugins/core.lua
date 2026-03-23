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
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      terminal = { enabled = true },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeStatus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>cs", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add tree file to Claude" },
      { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    opts = {},
  }
}
