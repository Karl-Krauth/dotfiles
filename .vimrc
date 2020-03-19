" Turn on syntax highlighting
syntax on

" Disable modelines for security.
set modelines=0

" Display more line info in vim.
set number
set ruler
set colorcolumn=101

" Disable sound on error.
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set indentation to 4 spaces.
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent

" Set solarized color scheme.
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
colorscheme solarized
highlight Comment cterm=NONE
hi Normal guibg=NONE ctermbg=NONE

" Set the vim copy buffer to be large.
set viminfo='20,<10000

" Show trailing whitespaces and tabs.
:highlight unwanted_characters ctermbg=red guibg=red
:match unwanted_characters /\s\+$\|\t/

" Enable backspacing
set backspace=indent,eol,start
