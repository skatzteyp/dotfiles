call plug#begin('~/.vim/plugged')

" IDE plugins
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'

" colors/themes
Plug 'skatzteyp/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'edkolev/promptline.vim'

" syntax
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" js
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" dart/flutter
Plug 'dart-lang/dart-vim-plugin'

call plug#end()
