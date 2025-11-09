" === CoC Extensions ===
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-styled-components',
      \ 'coc-json',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-tailwindcss',
      \ 'coc-emmet',
      \ ]

" === Core settings for CoC ===
set hidden
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

" === Tab completion ===
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible()
      \ ? coc#pum#next(1)
      \ : CheckBackspace() ? "\<Tab>" : coc#refresh()

inoremap <silent><expr> <S-Tab>
      \ coc#pum#visible()
      \ ? coc#pum#prev(1)
      \ : "\<C-h>"

inoremap <silent><expr> <CR>
      \ coc#pum#visible()
      \ ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Trigger completion
if has('nvim')
  inoremap <silent><expr> <C-Space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

" === Diagnostics ===
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" === Go-to ===
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" === Hover (guarded) ===
function! ShowDocumentation() abort
  if exists('*CocAction') && CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    execute 'normal! K'
  endif
endfunction

nnoremap <silent> K :call ShowDocumentation()<CR>

" === Highlight references on CursorHold (guarded) ===
augroup CocHighlight
  autocmd!
  autocmd CursorHold *
        \ if exists('*CocActionAsync') |
        \   silent call CocActionAsync('highlight') |
        \ endif
augroup END

" === Rename / Format / Code actions ===
nmap <leader>rn <Plug>(coc-rename)

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <leader>cl <Plug>(coc-codelens-action)

" Function / class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" === Float windows scroll ===
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll()
        \ ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll()
        \ ? coc#float#scroll(0) : "\<C-b>"

  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll()
        \ ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll()
        \ ? coc#float#scroll(0) : "\<C-b>"
endif

" === Range select ===
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" === Commands ===
command! -nargs=0 Format call CocActionAsync('format')
command! -nargs=0 Fold   call CocAction('fold', <f-args>)
command! -nargs=0 OR     call CocActionAsync('runCommand', 'editor.action.organizeImport')

" === Statusline (safe) ===
set statusline^=%{get(g:,'coc_status','')}%{get(b:,'coc_current_function','')}

" === CoCList mappings ===
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
