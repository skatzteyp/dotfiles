" === Leader ===
" Keep your existing leader choice (was set in nerdtree.vim before)
let mapleader = "\\"

" === Colors / Truecolor ===
silent! colorscheme onedark

if has('termguicolors')
  set termguicolors
endif

" === UI ===
set number                      " line numbers
set relativenumber              " relative numbers for motions
set scrolloff=4                 " keep context lines
set showmatch                   " highlight matching bracket
set noshowmode                  " statusline handles mode
set mouse=a                     " mouse support
set noswapfile                  " no swapfiles (personal preference)

" Whitespace
set list
set listchars=tab:\›\ ,trail:-,extends:>,precedes:<,eol:¬

" === Indent / Tabs ===
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start

" === Clipboard ===
if has('clipboard')
  set clipboard=unnamed,unnamedplus
endif

" === Window navigation ===
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" === Visual shifting ===
vnoremap <S-Tab> <gv
vnoremap <Tab> >gv

" === Transparent background (for nvim-transparent) ===
let g:transparent_enabled = v:true

" Disable all bells in Vim/Neovim
set noerrorbells
set novisualbell
set t_vb=
if exists('&belloff')
  set belloff=all
endif
