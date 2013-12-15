" ------------------------------------------------------------------------------
" vimrc
"
" Based on https://github.com/Soliah/dotfiles/blob/master/vimrc
" ------------------------------------------------------------------------------
" General Settings
" ------------------------------------------------------------------------------

set nocompatible " Turn off vi compatibility.
set undolevels=1000 " Large undo levels.
set history=200 " Size of command history.
set encoding=utf8 " Always use unicode.
set backspace=indent,eol,start " Fix backspace.

set nobackup " Disable backups.
set nowritebackup
set noswapfile

set notimeout " Fix lag in iTerm.
set ttimeout
set timeoutlen=50
set nomodeline

"filetype off                  " required!

" ------------------------------------------------------------------------------
" Vundle
" ------------------------------------------------------------------------------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

Bundle 'bling/vim-airline'
Bundle 'chriskempson/vim-tomorrow-theme'

" ------------------------------------------------------------------------------
" Binds
" ------------------------------------------------------------------------------
let mapleader = "," " Use comma as leader.

" ------------------------------------------------------------------------------
" Search and Replace
" ------------------------------------------------------------------------------
set incsearch " Show partial matches as search is entered.
set hlsearch " Highlight search patterns.
set ignorecase " Enable case insensitive search.
set smartcase " Disable case insensitivity if mixed case.
set wrapscan " Wrap to top of buffer when searching.
set gdefault " Make search and replace global by default.

" ------------------------------------------------------------------------------
" White Space
" ------------------------------------------------------------------------------
set tabstop=4 " Set tab to equal 4 spaces.
set softtabstop=4 " Set soft tabs equal to 4 spaces.
set shiftwidth=4 " Set auto indent spacing.
set shiftround " Shift to the next round tab stop.
set expandtab " Expand tabs into spaces.
set smarttab " Insert spaces in front of lines.
set listchars=tab:▸·,trail:· " Show leading whitespace
set list

" ------------------------------------------------------------------------------
" Presentation
" ------------------------------------------------------------------------------
set shortmess=aIoO " Show short messages, no intro.
set ttyfast " Fast scrolling when on a decent connection.
set nowrap " Wrap text.
set showcmd " Show last command.
set ruler " Show the cursor position.
set hidden " Allow hidden buffers.
set showmatch " Show matching parenthesis.
set matchpairs+=<:> " Pairs to match.
set cf " Enable error jumping.
syntax on " Enable syntax highlighting.
filetype on " Detect file type.
filetype indent on " Enable file indenting.
filetype plugin indent on " Load syntax files for better indenting.

" ------------------------------------------------------------------------------
" User Interface
" ------------------------------------------------------------------------------
let base16colorspace=256 " Access colors present in 256 colorspace
set background=light
colorscheme Tomorrow

if has('gui_running')
    set guioptions-=m " Disable menu bar.
    set guioptions-=T " Disable the tool bar bar.
    set guioptions-=a " Do not auto copy selection to clipboard.

    set guifont=Source\ Code\ Pro:h13
    set lines=36 " Window size.
    set columns=136
    set vb " Disable the audible bell.
endif

if has('mouse')
    set mouse=a " Enable mouse everywhere.
    set mousemodel=popup_setpos " Show a pop-up for right-click.
    set mousehide " Hide mouse while typing.
endif

" ------------------------------------------------------------------------------
" Status Line
" ------------------------------------------------------------------------------

" Always show status.
set laststatus=2

" Disable status line fill chars.
set fillchars+=stl:\ ,stlnc:\ " Space.
