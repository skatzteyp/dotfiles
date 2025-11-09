let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'component_function': {
  \   'filename': 'MyFilename',
  \   'mode': 'MyMode',
  \ },
  \ }

function! MyFilename()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? '' : fname
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERDTree' : lightline#mode()
endfunction
