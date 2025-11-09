-- Ensure lazy.nvim is installed (auto bootstrap)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- 📦 Core / QoL
  { "editorconfig/editorconfig-vim" },
  { "terryma/vim-multiple-cursors" },
  { "airblade/vim-gitgutter" },

  -- 🧠 LSP / IntelliSense
  { "neoclide/coc.nvim", branch = "release" },

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

  -- 📁 File explorer
  {
    "preservim/nerdtree",
    cmd = "NERDTreeToggle",
  },
  { "ryanoasis/vim-devicons" },

  -- 🚀 Navigation
  { "ThePrimeagen/harpoon" },

  -- 🧪 Testing
  { "vim-test/vim-test" },
  { "tpope/vim-dispatch" },

  -- 💅 UI / Theme
  { "itchyny/lightline.vim" },
  { "skatzteyp/onedark.vim" },
  { "edkolev/tmuxline.vim" },
  { "edkolev/promptline.vim" },
  { "xiyaowong/nvim-transparent" },

  -- 🌈 Languages
  -- JS / TS / React / Next.js
  { "leafgarland/typescript-vim" },
  { "peitalin/vim-jsx-typescript" },
  { "maxmellon/vim-jsx-pretty" },

  -- CSS / SCSS / styled-components
  { "styled-components/vim-styled-components", branch = "main" },
  { "cakebaker/scss-syntax.vim" },

  -- PHP / WordPress
  { "StanAngeloff/php.vim" },

  -- Vue
  { "posva/vim-vue" },

  -- Prisma
  { "pantharshit00/vim-prisma" },

  -- Liquid (Shopify)
  { "tpope/vim-liquid" },

  -- AI Assistant
  { "github/copilot.vim" },

})
