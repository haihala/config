" From https://medium.com/geekculture/neovim-configuration-for-beginners-b2116dbbde84
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set mouse=a                 " enable mouse click
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
set foldmethod=indent       " Lets you toggle fold with za, close with zc, open with zo

call plug#begin('~/.local/share/nvim/site/plugged')
    " Theme
    Plug 'dracula/vim'

    " No clue
    Plug 'ryanoasis/vim-devicons'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'mhinz/vim-startify'

    "" Automatically load lsp configs
    "Plug 'neovim/nvim-lspconfig'
    "Plug 'dundalek/lazy-lsp.nvim'

    " File explorer, f3 to open/focus
    Plug 'scrooloose/nerdtree'

    " Block comments
    " <leader>cc to comment selected
    " <leader>c<space> to toggle
    Plug 'preservim/nerdcommenter'

    " Completions, C-y/enter to accept, C-n for next, C-p for previous
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Fuzzy file search, f4 to open
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
call plug#end()

" Coc
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" color schemes
if (has("termguicolors"))
    set termguicolors
endif
syntax enable
" colorscheme evening
colorscheme dracula
" open new split panes to right and below
set splitright
set splitbelow

" Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

source $HOME/.config/nvim/binds.vim
