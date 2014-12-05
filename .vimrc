" Vundle
set nocompatible

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" The bundles you install will be listed here
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'klen/python-mode'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-bundler'
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'vim-scripts/vimrepress'
Bundle 'PotatoesMaster/i3-vim-syntax'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'mhinz/vim-signify'
Bundle 'vim-ruby/vim-ruby'
Bundle 'GutenYe/gem.vim'
Bundle 'stephpy/vim-yaml'

filetype plugin indent on

" Rebind <Leader> key
let mapleader = ","

" Bind nohl, removes highlight of your last search
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" disable arrow keys
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" easier moving between buffers
set hidden
map <Leader>h <esc>:bprevious<CR>
map <Leader>l <esc>:bnext<CR>
nmap <leader>bq :bp <BAR> bd #<CR>

" map sort function to a key
vnoremap <Leader>s :sort<CR>

" easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" Show whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
highlight BadWhitespace ctermbg=red guibg=red
match BadWhitespace /\s\+$/
au InsertLeave * match ExtraWhitespace /\s\+$/

" Color scheme
set t_Co=256
set background=dark

" Enable syntax highlighting
syntax on

" auto ident
set ai
set cin

" Showing line numbers and length
set number
set tw=79
set fo-=t " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=Grey

" easier formatting of paragraphs
vmap Q gq
vmap Q gqap

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use tabs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" 2 spaces instead of 4 for certain filetypes
autocmd FileType puppet set sts=2 sw=2 ts=2
autocmd FileType ruby set sts=2 sw=2 ts=2
autocmd FileType eruby set sts=2 sw=2 ts=2
autocmd FileType yaml set sts=2 sw=2 ts=2

" When there is a previous search pattern, highlight all its matches
set hlsearch

" Make search case insensitive
set incsearch
set ignorecase
set smartcase

" Disable stupid backup and swamp files - they trigger too many events for file system watchers
set nobackup
set nowritebackup
set noswapfile

" More powerful backspacing
set backspace=indent,eol,start

" Settings for nerdtree
map <F2> :NERDTreeToggle<CR>

" Allow saving of files as sudo when I forget to start vim with sudo
cmap w!! w !sudo tee > /dev/null %

" Enable mouse inside vim
set mouse=a

" Settings for vim-airline
set laststatus=2
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Settings for ctrlp
let g:ctrlp_max_height = 30
let g:ctrlp_show_hidden = 1
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*

" Settings for python-mode
let g:pymode_rope_goto_definition_cmd = "vnew"
let g:pymode_lint_ignore = ""
let g:pymode_breakpoint_cmd = 'import ipdb; ipdb.set_trace() # XXX BREAKPOINT'
let g:pymode_options = 0
map <Leader>g :call RopeGotoDefinition()<CR>
set nofoldenable

" Settings for vim-signify
let g:signify_vcs_list = [ 'git', 'hg' ]
