set nocompatible

let mapleader = " "

syntax on
set mouse=a

set encoding=utf-8
set fileencodings=utf-8
filetype plugin indent on

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
set clipboard=unnamedplus
set incsearch
set showcmd
set textwidth=72
set shortmess=aoOtTI

set matchpairs+=<:>   " Use % to jump between html tags as well
set path=$PWD/**      " enable fuzzy file search
set wildmenu          " enable fuzzy menu
set wildignore+=**/.git/**,**/__pychache__/**,**/venv/**,**/node_modules/**,**/dist/**.**/build/**,*.o,*.pyc,*swp
set hidden

set viminfo='10,\"100,:20,%,n~/.viminfo
augroup restoreline
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Fast rendering
set ttyfast

" Toggle Whitespace character rendering
nnoremap <leader>tl :set list!<CR>
set listchars=tab:>·,trail:~,extends:>,precedes:<,space:·,eol:↩

nnoremap <F5> :source $MYVIMRC<CR>

" Plugins
call plug#begin('~/.local/share/vim/plugins')

  " Language Server support
  Plug 'natebosch/vim-lsc'

  " Status line
  Plug 'itchyny/lightline.vim'

  " Color Schemes
  Plug 'NLKNguyen/papercolor-theme'

  " Debugging
  Plug 'puremourning/vimspector'

  " Essentials
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs'

  " Markdown with pandoc
  Plug 'vim-pandoc/vim-pandoc'   
  Plug 'vim-pandoc/vim-pandoc-syntax'   

call plug#end()

" ColorScheme Settings
if exists('+termguicolors') && ($TERM == "xterm-256color" || $TERM == "tmux-256color")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark

let g:PaperColor_Theme_Options = {
      \ 'theme': {
        \ 'default.dark': {
          \ 'override' : {
            \ 'color00' : ['#1B1E21', ''],
          \ }
        \ }
      \ }
    \ }

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

set noshowmode

" pandoc settings
let pandoc#formatting#textwidth = 72

" Language support (LSP) via vim-lsc
let g:lsc_server_commands = {
      \ 'rust': 'rust-analyzer',
      \ 'cpp': {
        \ 'command': 'clangd --background-index',
        \ 'suppress_stderr': v:true
        \ },
      \ 'c': {
        \ 'command': 'clangd --background-index',
        \ 'suppress_stderr': v:true
        \ },
      \}

let g:lsc_auto_map = {
      \ 'GoToDefinition': 'gd',
      \ 'FindReferences': 'gr',
      \ 'Rename': 'gR',
      \ 'ShowHover': 'K',
      \ 'FindCodeActions': 'ga',
      \ 'Completion': 'omnifunc',
      \}
let g:lsc_hover_popup = v:false

set completeopt=menu,menuone,noselect,noinsert

let g:lsc_enable_autocomplete = v:false
let g:lsc_enable_diagnostics = v:true
let g:lsc_reference_highlights = v:false
let g:lsc_trace_level = 'off'

set signcolumn=number

" Auto-Formatting code on save
function! FormatBuffer(cmd)
  if &modified
    let cursor_pos = getpos('.')
    execute "%!" . a:cmd
    if v:shell_error | undo | endif
    call setpos('.', cursor_pos)
  endif
endfunction

augroup autoformat
  au!
  if executable("clang-format")
    au BufWritePre *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx silent call FormatBuffer("clang-format")
  endif
  if executable("rustfmt")
    au BufWritePre *.rs silent call FormatBuffer("rustfmt")
  endif
augroup END

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
let g:vimspector_install_gadgets = ['CodeLLDB', 'vscode-cpptools', 'lldb-vscode']

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
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Increment and decrement numbers using arrow keys
nnoremap <Up> <C-a>
nnoremap <Down> <C-x>
