call plug#begin('~/.vim/plugged')

" 📦 Core / QoL
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'

" 🧠 LSP / IntelliSense
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" 🧹 Text objects / commenting
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'

" 🔍 Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 📁 File explorer
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'

" 🚀 Navigation
Plug 'ThePrimeagen/harpoon'

" 🧪 Testing
Plug 'vim-test/vim-test'
Plug 'tpope/vim-dispatch'

" 💅 UI / Theme
Plug 'itchyny/lightline.vim'
Plug 'skatzteyp/onedark.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'edkolev/promptline.vim'
Plug 'xiyaowong/nvim-transparent' " Neovim transparency

" 🌈 Languages

" JS / TS / React / Next.js
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
 Plug 'maxmellon/vim-jsx-pretty'

" CSS / SCSS / styled-components
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'cakebaker/scss-syntax.vim'

" Tailwind
Plug 'princejoogie/tailwind-highlight.nvim'

" PHP / WordPress
Plug 'StanAngeloff/php.vim'

" Vue (optional)
Plug 'posva/vim-vue'

" Prisma
Plug 'pantharshit00/vim-prisma'

" Liquid (Shopify)
Plug 'tpope/vim-liquid'

" AI Assistant
Plug 'github/copilot.vim'

call plug#end()
