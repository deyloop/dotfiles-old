set nocompatible

let mapleader = " "

syntax on
set mouse=a

set encoding=utf-8
set fileencodings=utf-8
filetype plugin indent on

set number relativenumber
set nowrap
set autoindent
set smartindent
set cindent
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2
set noswapfile
set nobackup
set backspace=indent,eol,start
set splitbelow
set cursorline
set colorcolumn=80
set clipboard=unnamed
set incsearch
set showcmd

set matchpairs+=<:>   " Use % to jump between html tags as well
set path=$PWD/**      " enable fuzzy file search
set wildmenu          " enable fuzzy menu
set wildignore+=**/.git/**,**/__pychache__/**,**/venv/**,**/node_modules/**,**/dist/**.**/build/**,*.o,*.pyc,*swp
set hidden

" Fast rendering
set ttyfast

" Toggle Whitespace character rendering
nnoremap <leader>tl :set list!<CR>
set listchars=tab:>·,trail:~,extends:>,precedes:<,space:·

nnoremap <F5> :source $MYVIMRC<CR>

set completeopt=menu,menuone,preview,noselect,noinsert
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_autoimport = 1

" Plugins
call plug#begin('~/.local/share/vim/plugins')

  Plug 'dense-analysis/ale'

  " Status line
  Plug 'itchyny/lightline.vim'

  " Color Schemes
  Plug 'NLKNguyen/papercolor-theme'

  " Debugging
  Plug 'puremourning/vimspector'

call plug#end()

" ColorScheme Settings
set termguicolors
set background=dark
set noshowmode

colorscheme PaperColor

set laststatus=2
let g:lightline = {
      \ 'colorscheme' : 'PaperColor',
      \ 'mode_map': {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
        \ },
      \ }

" Language support (LSP) via ALE
let g:ale_linters = {
  \'rust': ['cargo', 'analyzer'],
  \'cpp': ['clangd'],
  \'c': ['clangd']
\}

let g:ale_fixers = {
  \'rust' : ['rustfmt']
\}

let g:ale_fix_on_save = 1

nnoremap gd :ALEGoToDefinition<CR>

set signcolumn=number

" Code folding
set nofoldenable
function! MyFoldText()
    let line = getline(v:foldstart)
    let foldedlinecount = v:foldend - v:foldstart + 1
    return ' «» '. foldedlinecount . ' ' . line
endfunction
set foldtext=MyFoldText()
set fillchars=fold:\ 

" Debugging using Vimspector
let g:vimspector_install_gadgets = ['CodeLLDB']

nmap <leader>dd <Plug>VimspectorContinue
nmap <leader>dx <Plug>VimspectorStop
nmap <leader>dR <Plug>VimspectorRestart
nmap <leader>dp <Plug>VimspectorPause
nmap <leader>dbt <Plug>VimspectorToggleBreakpoint
nmap <leader>dbc <Plug>VimspectorToggleConditionalBreakpoint
nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dn <Plug>VimspectorStepOver
nmap <leader>ds <Plug>VimspectorStepInto
nmap <leader>du <Plug>VimspectorStepOut
nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval

" netrw -- if I ever need it
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
