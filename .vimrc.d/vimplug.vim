call plug#begin('~/.vim/plugged')

" IDE plugins
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'eslint/eslint'

" colors/themes
Plug 'skatzteyp/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'edkolev/promptline.vim'

" syntax highlighters

" js
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" dart/flutter
Plug 'dart-lang/dart-vim-plugin'

" vue
Plug 'posva/vim-vue'

" jsx/typescript/styled components
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" php
Plug 'StanAngeloff/php.vim'

" scss
Plug 'cakebaker/scss-syntax.vim'

" liquid
Plug 'tpope/vim-liquid'

" transparent bg
Plug 'xiyaowong/nvim-transparent'

call plug#end()
