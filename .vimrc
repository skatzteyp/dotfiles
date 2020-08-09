source ~/.vimrc.d/vimplug.vim

for vscript in split(glob('~/.vimrc.d/conf/*.vim'), '\n')
	exe 'source' vscript
endfor

source ~/.vimrc.d/main.vim
