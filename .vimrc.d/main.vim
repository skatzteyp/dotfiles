" set color here
color onedark

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" for autoindent
set smartindent
set scrolloff=4
set showmatch
set noshowmode
set number
set relativenumber
set noswapfile
set mouse=a

" show white spaces
set list listchars=tab:\›\ ,trail:-,extends:>,precedes:<,eol:¬

" easy window moving
no <C-j> <C-W>j
no <C-k> <C-W>k
no <C-h> <C-W>h
no <C-l> <C-W>l

" shift tab and tab shortcut
vmap <S-Tab> <gv
vmap <Tab> >gv

" show existing tab with 2 spaces width
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 2 spaces
set expandtab
" Use OS clipboard
set clipboard=unnamed
" Remove other chars on backspace
set backspace=indent,eol,start
