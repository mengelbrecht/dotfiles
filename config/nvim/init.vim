" ------------------------------------------------------------------------------
" vimrc
"
" Inspired by
"   https://github.com/Soliah/dotfiles/blob/master/vimrc
"   https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim
"   https://github.com/junegunn/dotfiles/blob/master/vimrc
"   https://github.com/mhinz/dotfiles/blob/master/vim/vimrc
"   https://github.com/cHoco/dotFiles/blob/master/vimrc
"   https://github.com/pgdouyon/dotfiles/blob/master/config/nvim/init.vim
" ------------------------------------------------------------------------------

set runtimepath+=$HOME/.config/nvim/plug

" Setup plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'joshdick/onedark.vim'
call plug#end()

" General {{{
let mapleader                 = "\<SPACE>"

if has('vim_starting')
  set encoding=utf8        " Always use unicode
endif
set shell=$SHELL           " Use zsh as shell
set viminfo=/100,:100,'100 " Save command history and search patterns
set autoread               " Automatically load changes
set undolevels=1000        " Large undo levels
set history=200            " Size of command history
set nobackup               " Disable backups
set clipboard=unnamed      " Use the OS clipboard by default
set ttyfast                " Optimize for fast terminal connections
set lazyredraw             " Wait to redraw
set ttimeout               " Timeout on keycodes
set ttimeoutlen=10         " Small timeout to reduce lag when pressing ESC in terminal
" }}}

" Completion {{{
set completeopt-=preview       " Disable preview window
set wildmenu                   " Show list
set wildmode=longest:full,full " Show all matches
" }}}

" Searching {{{
set incsearch                  " Show partial matches as search is entered.
set hlsearch                   " Highlight search patterns.
set ignorecase                 " Enable case insensitive search.
set smartcase                  " Disable case insensitivity if mixed case.
set gdefault                   " Make search and replace global by default.
" }}}

" Whitespace {{{
set autoindent           " Keep indentation
set tabstop=4            " Set tab to equal 4 spaces
set softtabstop=4        " Set soft tabs equal to 4 spaces
set shiftwidth=4         " Set auto indent spacing
set shiftround           " Shift to the next round tab stop
set expandtab            " Expand tabs into spaces
set smarttab             " Insert spaces in front of lines
set list                 " Show whitespace
set listchars=tab:╶─     " Tab symbol
set listchars+=trail:·   " Trailing whitespace
set listchars+=extends:# " Character to show when wrap is off
set listchars+=nbsp:%    " Non breakable whitespace
" }}}

" Basic UX {{{
set backspace=indent,eol,start " Fix backspace
set confirm                    " Confirm instead of fail
set cursorline                 " Highlight current line
set foldlevelstart=0           " Close all folds by default
set foldmethod=marker          " Use markers for folds
set fillchars=vert:│           " Use longest bar for vertical split
set fillchars+=fold:─          " Use longest dash for folds
set hidden                     " Allow hidden buffers
set laststatus=2               " Always show status line
set linespace=1                " Use 1 pixel space between lines
set matchpairs+=<:>            " Pairs to match
set noerrorbells               " Disable error bells
set nomodeline                 " Hide modeline
set noshowmode                 " No need to show mode
set nostartofline              " Do not move cursor to start of line after line-wise command
set nowrap                     " Wrap text
set number                     " Enable line numbers
set scrolljump=8               " Scroll 8 lines at a time at top/bottom
set scrolloff=5                " Always show one line above and below cursor
set shortmess=aIoO             " Show short messages, no intro
set showcmd                    " Show last command
set showmatch                  " Show matching parenthesis
set showtabline=2              " Always show the tabline
set sidescrolloff=5            " Always show 5 columns before and after cursor
set signcolumn=yes             " Display sign column
set splitbelow                 " Open new splits below
set splitright                 " Open new splits on the right
set switchbuf=usetab           " Switch to the window of the buffer
set synmaxcol=240              " Limit syntax highlighting to 240 colums
set vb t_vb=                   " Disable visual bell
set virtualedit=onemore        " Allow for cursor beyond last character
set whichwrap+=<,>,h,l,[,]     " Move lines using arrows.

" Inspired by http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! CustomFoldText()
  let l:name = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g')
  let l:lines = v:foldend - v:foldstart + 1
  let l:foldchar = matchstr(&fillchars, 'fold:\zs.')
  let l:end = l:lines . ' lines ' . printf('%4.1f', l:lines*100.0/line('$')) . '% ' . repeat(l:foldchar, 4)
  let l:width = winwidth(0) - strwidth(l:end) - &foldcolumn - &numberwidth - 2 " 2 for sign colum
  let l:start = strpart(repeat(l:foldchar, 5) . repeat('━' . l:foldchar . l:foldchar, v:foldlevel - 1) . ' ' . l:name . ' ', 0, l:width)
  return l:start . repeat(' ', l:width  - strwidth(l:start)) . l:end
endfunction
set foldtext=CustomFoldText()
" }}}

" Terminal UX {{{
set t_Co=256 " Terminal supports 256 colors
set t_md=    " Disable bold fonts in terminal

" Enable italics
let &t_ZH = "\e[3m"
let &t_ZR = "\e[23m"

if has('termguicolors')
  set termguicolors " Enable 24bit colors in terminal
endif

let g:onedark_terminal_italics = 1
let g:lightline#onedark#disable_bold_style = 1

set background=dark
colorscheme onedark
" }}}

" GUI {{{
if has('gui_running')
  set fullscreen
  set guicursor=a:blinkon0 " Non blinking cursor
  set guioptions-=m        " Disable menu bar
  set guioptions-=T        " Disable the toolbar
  set guioptions-=a        " Do not auto copy selection to clipboard
  set guioptions-=e        " Do not use gui tab apperance
  set guioptions-=r        " Do not show scrollbars
  set guioptions-=R        " Do not show scrollbars
  set guioptions-=l        " Do not show scrollbars
  set guioptions-=L        " Do not show scrollbars
  set guifont=PragmataPro\ Mono:h14
endif
" }}}

" Misc Mappings {{{
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Toggle wrapping
map <F2> :set wrap!<CR>

" Invert result highlighting
nnoremap <silent> _ :set invhlsearch<CR>
" }}}

" Buffer Mappings {{{
nnoremap <silent> <C-t> :enew<CR>
nnoremap <silent> <C-x> :bd<CR>
nnoremap <silent> <C-u> :bprev<CR>
nnoremap <silent> <C-i> :bnext<CR>
" }}}

" Cut Mappings {{{
" Replace and delete do not copy text to register and cut text with m (move)
nnoremap m d
vnoremap m d
nnoremap M D
vnoremap M D
vnoremap p "_dP
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X
" }}}

" Lightline
let g:lightline = {
\ 'colorscheme': 'one',
\ 'active': {
\ 'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
\ },
\ 'tabline': {
\ 'left': [ ['buffers'] ],
\ 'right': [ ['close'] ]
\ },
\ 'component_expand': {
\ 'buffers': 'lightline#bufferline#buffers'
\ },
\ 'component_type': {
\ 'buffers': 'tabsel'
\ },
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' },
\ 'component': {
\ 'lineinfo': ' %3l:%-2v',
\ },
\ }
" }}}
