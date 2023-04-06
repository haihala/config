" Space to leader
nnoremap <Space> <Nop>
let mapleader = "\<Space>"

" Reload config
nnoremap <leader>sv :source $MYVIMRC<CR>

" move line or visually selected block - alt+j/k
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" move split panes to left/bottom/top/right
nnoremap <C-h> <C-W>H
nnoremap <C-j> <C-W>J
nnoremap <C-k> <C-W>K
nnoremap <C-l> <C-W>L

" move between panes to left/bottom/top/right
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Go back
nmap <silent> gb :e#<CR>

" coc navigation
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gr <Plug>(coc-references)
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap gn <Plug>(coc-git-nextchunk)
nnoremap gp <Plug>(coc-git-prevchunk)

" LSP diagnostics
nnoremap Dl :<C-u>CocList diagnostics<CR>
nnoremap <silent> Dn <Plug>(coc-diagnostic-next)
nnoremap <silent> Dp <Plug>(coc-diagnostic-prev)

" LSP actions
nnoremap <leader>r <Plug>(coc-rename)
nnoremap <leader>R <Plug>(coc-codeaction-refactor)
nnoremap <leader>a <Plug>(coc-codeaction-cursor)
nnoremap <leader>A <Plug>(coc-fix-current)
command! -nargs=0 OrganizeImports :call CocActionAsync('runCommand', 'editor.action.organizeImport')
nnoremap <leader>d :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Git diff
nnoremap <leader>gd <Plug>(coc-git-chunkinfo)

" Searching
" c[ontent], f[iles], g[it changes]
nnoremap <leader>fc :Rg<CR>
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fF :Files<CR>
nnoremap <leader>fg :GFiles?<CR>
nnoremap <leader>ft :NERDTreeFind<CR>

