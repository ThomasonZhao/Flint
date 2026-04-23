" ── Flint .vimrc ──────────────────────────────────────────────
" Practical defaults for occasional-to-moderate Vim use.
" No plugins required — everything here ships with Vim.

" ── General ───────────────────────────────────────────────────
set nocompatible              " use Vim defaults, not Vi
filetype plugin indent on     " detect filetypes and load plugins
syntax on                     " syntax highlighting

set encoding=utf-8            " UTF-8 everywhere
set hidden                    " allow switching buffers without saving
set autoread                  " reload files changed outside Vim
set history=1000              " generous command history
set undolevels=1000           " generous undo

" ── Display ───────────────────────────────────────────────────
set number                    " line numbers
set relativenumber            " relative numbers (easy jumps: 5j, 12k)
set cursorline                " highlight current line
set showcmd                   " show partial commands in status line
set showmode                  " show current mode
set laststatus=2              " always show status line
set ruler                     " cursor position in status line
set scrolloff=8               " keep 8 lines above/below cursor
set sidescrolloff=8           " keep 8 columns left/right of cursor
set signcolumn=auto           " show sign column when needed
set wildmenu                  " visual autocomplete for commands
set wildmode=longest:full,full

" ── Indentation ───────────────────────────────────────────────
set expandtab                 " spaces, not tabs
set tabstop=4                 " display width of \t
set shiftwidth=4              " indent width for >> and auto
set softtabstop=4             " spaces inserted per <Tab>
set smartindent               " smart auto-indenting
set shiftround                " round indent to multiple of shiftwidth

" ── Search ────────────────────────────────────────────────────
set incsearch                 " search as you type
set hlsearch                  " highlight matches
set ignorecase                " case-insensitive search...
set smartcase                 " ...unless you use uppercase

" ── Splits ────────────────────────────────────────────────────
set splitbelow                " new horizontal splits go below
set splitright                " new vertical splits go right

" ── Wrapping ──────────────────────────────────────────────────
set wrap                      " soft-wrap long lines
set linebreak                 " wrap at word boundaries
set breakindent               " preserve indent in wrapped lines

" ── Backspace / Clipboard ────────────────────────────────────
set backspace=indent,eol,start  " backspace works as expected
set clipboard=unnamed           " yank/paste uses system clipboard

" ── Performance ───────────────────────────────────────────────
set lazyredraw                " don't redraw during macros
set ttyfast                   " fast terminal connection
set updatetime=250            " faster CursorHold (default 4000)
set timeoutlen=500            " mapping timeout (ms)

" ── Persistent undo ───────────────────────────────────────────
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undodir
    silent! call mkdir($HOME . '/.vim/undodir', 'p')
endif

" ── No swap/backup clutter ────────────────────────────────────
set noswapfile
set nobackup
set nowritebackup

" ── Leader key ────────────────────────────────────────────────
let mapleader = ' '           " Space as leader — easy to reach

" ── Key mappings ──────────────────────────────────────────────

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Quick save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Move between splits with Ctrl + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep search results centered
nnoremap n nzzzv
nnoremap N Nzzzv

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Y yanks to end of line (consistent with C and D)
nnoremap Y y$

" Quick buffer switching
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :ls<CR>

" Open file explorer
nnoremap <leader>e :Explore<CR>

" ── netrw (built-in file explorer) ────────────────────────────
let g:netrw_banner = 0        " hide the help banner
let g:netrw_liststyle = 3     " tree view
let g:netrw_winsize = 25      " 25% width

" ── Colorscheme ───────────────────────────────────────────────
" Use a built-in scheme that looks good in most terminals
set background=dark
silent! colorscheme retrobox
