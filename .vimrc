" {{{ NO COMPATIBLE (vi)
set nocp
" }}}

" {{{ CSCOPE
set csprg=cscope
set cst
" }}}

" {{{ LINE NUMBERS
set nu
" }}}

" {{{ TAB
set ts=4
set sw=4
set sts=4
set noet
" }}}

autocmd FileType puppet set sts=2 sw=2 ts=2
autocmd FileType ruby set sts=2 sw=2 ts=2

" {{{ INDENT
set ai
set cin
" }}}

" {{{ PLUGINS
set lpl
" }}}
"
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>

"set textwidth=80
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.pl,*.pm set textwidth=80

set modeline

syntax on
filetype indent on
set autoindent

set backspace=indent,eol,start        " more powerful backspacing
set wildmenu
set ek hidden ruler sc vb wmnu
set nodigraph noeb nosol

highlight BadWhitespace ctermbg=red guibg=red
match BadWhitespace /\s\+$/

set autoindent shiftwidth=4 expandtab
set background=dark
if &t_Co > 1
    syntax enable
endif
