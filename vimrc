" ------------------------------------------------------------------------------
" vimrc
"
" Based on vim configuration by Christopher Chow
"     https://github.com/Soliah/dotfiles/blob/master/vimrc
"     https://github.com/Soliah/dotfiles/tree/master/vim
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" Plugins
" ------------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'cespare/vim-sbd'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'joshdick/airline-onedark.vim'
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
call plug#end()

" ------------------------------------------------------------------------------
" General Settings
" ------------------------------------------------------------------------------
set undolevels=1000 " Large undo levels.
set history=200 " Size of command history.
set encoding=utf8 " Always use unicode.
set backspace=indent,eol,start " Fix backspace.

set nobackup " Disable backups.
set nowritebackup
set noswapfile

let g:netrw_dirhistmax = 0 " Disable .netrwhist file creation

set clipboard=unnamed " Use the OS clipboard by default

set ttyfast " Optimize for fast terminal connections

set notimeout
set ttimeout
set timeoutlen=50
set nomodeline
set autochdir " Automatically change to directory of current file.
set wildchar=<Tab> wildmenu wildmode=full
set whichwrap+=<,>,h,l,[,] " Move lines using arrows.

nnoremap <SPACE> <Nop>
let mapleader=" "

" ------------------------------------------------------------------------------
" Search and Replace
" ------------------------------------------------------------------------------
set incsearch " Show partial matches as search is entered.
set hlsearch " Highlight search patterns.
set ignorecase " Enable case insensitive search.
set smartcase " Disable case insensitivity if mixed case.
set wrapscan " Wrap to top of buffer when searching.
set gdefault " Make search and replace global by default.

" Clear results.
nnoremap <silent> <Leader><Leader> :noh<CR>

" ------------------------------------------------------------------------------
" White Space
" ------------------------------------------------------------------------------
set tabstop=4 " Set tab to equal 4 spaces.
set softtabstop=4 " Set soft tabs equal to 4 spaces.
set shiftwidth=4 " Set auto indent spacing.
set shiftround " Shift to the next round tab stop.
set expandtab " Expand tabs into spaces.
set smarttab " Insert spaces in front of lines.
set listchars=eol:¬,tab:\|\ ,trail:·" Show leading whitespace
set list

" Bind F5 to remove trailing whitespace.
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR> " Use F5 to remove all trailing spaces

" ------------------------------------------------------------------------------
" Buffers
" ------------------------------------------------------------------------------
nnoremap <silent> <C-t> :enew<cr>
nnoremap <silent> <C-x> :Sbd<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-k> :bprev<CR>

" ------------------------------------------------------------------------------
" Presentation
" ------------------------------------------------------------------------------
set gcr=a:blinkon0 " Non blinking cursor
set shortmess=aIoO " Show short messages, no intro.
set ttyfast " Fast scrolling when on a decent connection.
set nowrap " Wrap text.
set showcmd " Show last command.
set ruler " Show the cursor position.
set hidden " Allow hidden buffers.
set showmatch " Show matching parenthesis.
set matchpairs+=<:> " Pairs to match.
set cf " Enable error jumping.
set number " Enable line numbers

if exists('+colorcolumn')
    set colorcolumn=100
endif

" ------------------------------------------------------------------------------
" User Interface
" ------------------------------------------------------------------------------
set t_Co=256
set background=dark
if !has('gui_running')
    let g:onedark_termcolors=16
endif
colorscheme onedark

if has('gui_running')
    set linespace=1
    set fuoptions=maxvert,maxhorz
    set guioptions-=m " Disable menu bar.
    set guioptions-=T " Disable the tool bar bar.
    set guioptions-=a " Do not auto copy selection to clipboard.
    set guioptions-=e " don't use gui tab apperance
    set guioptions-=r " don't show scrollbars
    set guioptions-=l " don't show scrollbars
    set guioptions-=R " don't show scrollbars
    set guioptions-=L " don't show scrollbars
    set stal=2 " turn on tabs by default
    set gtl=%t gtt=%F " tab headings
    set guifont=PragmataPro:h14
    set lsp=2
    set vb " Disable the audible bell.

    set macligatures
endif

" ------------------------------------------------------------------------------
" Airline
" ------------------------------------------------------------------------------
set laststatus=2
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse=0

" Disable status line fill chars.
set fillchars+=stl:\ ,stlnc:\ " Space.

" ------------------------------------------------------------------------------
" NERDTree
" ------------------------------------------------------------------------------
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" ------------------------------------------------------------------------------
" Syntastic
" ------------------------------------------------------------------------------
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_ballons=has('ballon_eval')
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=3
