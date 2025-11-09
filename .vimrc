" Load plugins
source $HOME/.vimrc.d/vimplug.vim

" Load plugin-specific configs
for vscript in split(glob('$HOME/.vimrc.d/conf/*.vim'), '\n')
  if filereadable(vscript)
    execute 'source' vscript
  endif
endfor

" Load main editor settings (UI, mappings, etc.)
source $HOME/.vimrc.d/main.vim
