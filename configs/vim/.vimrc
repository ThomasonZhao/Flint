"Plugins
call plug#begin()

" Interface
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Integration
Plug 'tpope/vim-fugitive'

" Completion
Plug 'valloric/youcompleteme'
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Code display
Plug 'altercation/vim-colors-solarized'
let g:solarized_termcolors=256

call plug#end()

"Configs
syntax enable
filetype plugin indent on
colorscheme solarized

set encoding=utf-8
set t_Co=256
set background=dark

set number
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set hlsearch
set incsearch
set mouse=a
set paste
