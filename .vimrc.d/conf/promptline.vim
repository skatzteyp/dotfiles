" Use our lightline colors!
let g:promptline_theme = {
    \   'a'    : [ 0, 4 ],
    \   'b'    : [ 253, 239 ],
    \   'c'    : [ 244, 0 ],
    \   'x'    : [ 244, 0 ],
    \   'y'    : [ 253, 239 ],
    \   'z'    : [ 0, 4 ],
    \   'warn' : [232, 166]
    \ }

" We don't need much
let g:promptline_preset = {
	\'a':    [ promptline#slices#user() ],
	\'b':    [ promptline#slices#cwd() ],
	\'y':    [ promptline#slices#git_status() ],
	\'z':    [ promptline#slices#vcs_branch() ],
	\'warn': [ promptline#slices#last_exit_code(), promptline#slices#jobs() ]
\}

" Disable the custom font.
let g:promptline_powerline_symbols = 0
