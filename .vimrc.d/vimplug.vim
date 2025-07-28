call plug#begin('~/.vim/plugged')

" 📦 Plugin Manager & Tools
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'

" 🧠 IDE Features
Plug 'neoclide/coc.nvim', { 'branch': 'release' }     " LSP, IntelliSense
Plug 'prettier/vim-prettier', { 'do': 'yarn install' } " Optional if using coc-prettier
Plug 'airblade/vim-gitgutter'                          " Git diff in gutter

" 🧹 Formatting & Comments
Plug 'tpope/vim-surround'           " e.g. cs"' to change " to '
Plug 'tpope/vim-commentary'         " gcc to comment lines (simpler than nerdcommenter)

" 🔍 Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 📁 File Explorer
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'      " NerdTree icons (requires patched font)

" 🗃️ Productivity
Plug 'ThePrimeagen/harpoon'        " Quick file jumping
Plug 'wellle/targets.vim'          " Better motions and text objects

" 🧪 Test Runner
Plug 'vim-test/vim-test'
Plug 'tpope/vim-dispatch'          " Optional async test runner

" 💅 UI / Themes
Plug 'itchyny/lightline.vim'       " Lightweight statusline
Plug 'xiyaowong/nvim-transparent'  " Transparent background
Plug 'skatzteyp/onedark.vim'       " Theme
Plug 'edkolev/tmuxline.vim'        " Tmux status line
Plug 'edkolev/promptline.vim'      " Shell prompt generator

" 🌈 Syntax & Language Support

" JS/TS/React
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Optional (pick one for JSX highlighting, not both)
" Plug 'maxmellon/vim-jsx-pretty'

" CSS / Styled Components / Tailwind
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'cakebaker/scss-syntax.vim'

" Tailwind classes highlighting (optional)
Plug 'princejoogie/tailwind-highlight.nvim', { 'do': ':TailwindHighlight' }

" PHP / WordPress
Plug 'StanAngeloff/php.vim'

" Vue (if needed)
Plug 'posva/vim-vue'

" Dart / Flutter (optional)
Plug 'dart-lang/dart-vim-plugin'

" Liquid (Shopify)
Plug 'tpope/vim-liquid'

" AI Coding Assistant
Plug 'github/copilot.vim'

call plug#end()
