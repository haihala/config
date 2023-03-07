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

" coc
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <F2> <Plug>(coc-rename)
nnoremap <F3> :NERDTreeFocus<CR>
nnoremap <F4> :Files<CR>

" Reload config
nnoremap <leader>sv :source $MYVIMRC<CR>

