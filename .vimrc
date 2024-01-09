colorscheme spartan

call plug#begin()

Plug 'ap/vim-buftabline'
Plug 'francoiscabrol/ranger.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'mattn/vim-lsp-settings'
Plug 'nelstrom/vim-visual-star-search'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'

call plug#end()

let g:lightline = {
\   'colorscheme': 'seoul256',
\   'active': {
\     'left': [['mode'], ['filename']],
\     'right': [['lineinfo'], ['percent'], ['filetype']]
\   },
\   'inactive': {
\     'left': [['filename']],
\     'right': [[]]
\   },
\   'tabline': {
\     'left': [['tabs']],
\     'right': [[]]
\   },
\   'tab': {
\     'active': ['filename', 'modified'],
\     'inactive': ['filename', 'modified']
\   }
\ }

let g:ranger_replace_netrw = 1

let g:lsp_hover_ui = 'preview'
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_document_code_action_signs_enabled = 0

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

nnoremap <silent> <space>f :LspDocumentFormat<CR>

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

filetype plugin on
filetype indent on

syntax enable
set noerrorbells
set novisualbell
set belloff=all

set backspace=indent,eol,start " enable backspace

set nobackup
set nowritebackup
set noswapfile

set lazyredraw
set wildmenu
set noshowmode
set nocompatible
set number
set nowrap

set hlsearch
nnoremap <C-M> :nohlsearch<CR>

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set splitright
set updatetime=100
set laststatus=2 " make lightline visible

set hidden
nnoremap <C-D> :bdelete<CR>

nnoremap <C-P> :Files<CR>

set colorcolumn=80
set cursorline
set cursorlineopt=line
highlight ColorColumn ctermbg=235
highlight CursorLine ctermbg=235

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

tnoremap <Esc> <C-\><C-n>
