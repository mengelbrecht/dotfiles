" ------------------------------------------------------------------------------
" vimrc
"
" Inspired by
"     https://github.com/Soliah/dotfiles/blob/master/vimrc
"     https://github.com/Soliah/dotfiles/tree/master/vim
"     https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" Plugins
" ------------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()
Plug 'JazzCore/ctrlp-cmatcher', {'do': 'CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments ./install.sh'}
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'cespare/vim-sbd'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'joshdick/onedark.vim'
Plug 'myint/indent-finder'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'rakr/vim-one'
Plug 'rhysd/vim-clang-format'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'mileszs/ack.vim'

" Languages
Plug 'b4winckler/vim-objc'
Plug 'keith/swift.vim'
Plug 'mitsuhiko/vim-python-combined'
Plug 'nickhutchinson/vim-cmake-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'tbastos/vim-lua'
Plug 'tpope/vim-git'
Plug 'vim-ruby/vim-ruby'
call plug#end()

" ------------------------------------------------------------------------------
" General Settings
" ------------------------------------------------------------------------------
let mapleader = "\<SPACE>"
let g:netrw_dirhistmax = 0 " Disable .netrwhist file creation

set autoread " Automatically load changes
set undolevels=1000 " Large undo levels
set history=200 " Size of command history
set encoding=utf8 " Always use unicode
set backspace=indent,eol,start " Fix backspace
set nobackup " Disable backups
set nowritebackup
set noswapfile
set clipboard=unnamed " Use the OS clipboard by default
set ttyfast " Optimize for fast terminal connections
set notimeout " No timeout on mappings
set ttimeout " Timeout on keycodes
set ttimeoutlen=100
set nomodeline
set wildchar=<Tab> " Complete with Tab
set wildmenu " Show list
set wildmode=longest:full,full " Show all matches
set whichwrap+=<,>,h,l,[,] " Move lines using arrows.
set virtualedit=onemore " Allow for cursor beyond last character
set switchbuf=usetab " Switch to the window of the buffer

set incsearch " Show partial matches as search is entered.
set hlsearch " Highlight search patterns.
set ignorecase " Enable case insensitive search.
set smartcase " Disable case insensitivity if mixed case.
set wrapscan " Wrap to top of buffer when searching.
set gdefault " Make search and replace global by default.

set autoindent " Keep indentation
set tabstop=4 " Set tab to equal 4 spaces
set softtabstop=4 " Set soft tabs equal to 4 spaces
set shiftwidth=4 " Set auto indent spacing
set shiftround " Shift to the next round tab stop
set expandtab " Expand tabs into spaces
set smarttab " Insert spaces in front of lines
set list " Show whitespace
set listchars=tab:╶─ " Tab symbol
set listchars+=trail:· " Trailing whitespace
set listchars+=extends:# " Symbol for more text
set listchars+=nbsp:. " Show whitespace

set cf " Enable error jumping.
set gcr=a:blinkon0 " Non blinking cursor
set hidden " Allow hidden buffers
set matchpairs+=<:> " Pairs to match
set nowrap " Wrap text
set number " Enable line numbers
set ruler " Show the cursor position
set shortmess=aIoO " Show short messages, no intro
set showcmd " Show last command
set showmatch " Show matching parenthesis
set synmaxcol=240 " Limit syntax highlighting to 240 colums
set ttyfast " Fast scrolling when on a decent connection
set linespace=1
set laststatus=2
set fillchars+=stl:\ ,stlnc:\ " Space " Disable status line fill chars

if exists('+colorcolumn')
  set colorcolumn=80,100,120
endif

set t_Co=256
set background=dark

if has("termguicolors")
  set termguicolors
endif

if has('gui_running')
  set guioptions-=m " Disable menu bar
  set guioptions-=T " Disable the toolbar
  set guioptions-=a " Do not auto copy selection to clipboard
  set guioptions-=e " Do not use gui tab apperance
  set guioptions-=r " Do not show scrollbars
  set guioptions-=l " Do not show scrollbars
  set guioptions-=R " Do not show scrollbars
  set guioptions-=L " Do not show scrollbars
  set stal=2 " turn on tabs by default
  set gtl=%t gtt=%F " tab headings
  set lsp=2
  set vb " Disable the audible bell

  if has('gui_macvim')
    set guifont=PragmataPro\ Mono:h14
    set macligatures
    if &background ==# "dark"
      set macthinstrokes
    end
  endif
endif

" ------------------------------------------------------------------------------
" Keymappings
" ------------------------------------------------------------------------------
" Correct common shift key misspellings
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Visual shifting (without exiting visual mode)
vnoremap < <gv
vnoremap > >gv

map <F2> :set wrap!<CR> " Toggle wrapping

" Invert result highlighting
nnoremap <silent> _ :set invhlsearch<CR>

" Find merge conflict markers
nnoremap <Leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Easier window switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent> <C-t> :enew<CR>
nnoremap <silent> <C-x> :Sbd<CR> " Smart buffer delete
nnoremap <silent> <C-u> :bprev<CR>
nnoremap <silent> <C-i> :bnext<CR>

nnoremap <silent> <Leader>t :tabnew<CR>
nnoremap <silent> <Leader>x :bd<CR>
nnoremap <silent> <Leader>u :tabprevious<CR>
nnoremap <silent> <Leader>i :tabnext<CR>
noremap <silent> <D-1> :tabn 1<CR>
noremap <silent> <D-2> :tabn 2<CR>
noremap <silent> <D-3> :tabn 3<CR>
noremap <silent> <D-4> :tabn 4<CR>
noremap <silent> <D-5> :tabn 5<CR>
noremap <silent> <D-6> :tabn 6<CR>
noremap <silent> <D-7> :tabn 7<CR>
noremap <silent> <D-8> :tabn 8<CR>
noremap <silent> <D-9> :tabn 9<CR>

" ------------------------------------------------------------------------------
" Autocommands
" ------------------------------------------------------------------------------
augroup FileTypeSettings
  " Detect gyp files
  autocmd BufRead,BufNewFile *.gyp,*.gypi setlocal filetype=python
augroup END

" ------------------------------------------------------------------------------
" Colorscheme
" ------------------------------------------------------------------------------
let g:one_allow_italics = 1
let g:onedark_terminal_italics = 1

if !has('gui_running')
  let g:one_termcolors=16
  let g:onedark_termcolors=16
endif

colorscheme onedark

if g:colors_name ==# "onedark"
  let s:ws_guifg = synIDattr(synIDtrans(hlID("Cursor")), "fg", "gui")
  let s:ws_ctermfg = synIDattr(synIDtrans(hlID("Cursor")), "fg", "cterm")
  let s:ws_guibg = synIDattr(synIDtrans(hlID("SpellBad")), "fg", "gui")
  let s:ws_ctermbg = synIDattr(synIDtrans(hlID("SpellBad")), "fg", "cterm")
elseif g:colors_name ==# "one"
  let s:ws_guifg = synIDattr(synIDtrans(hlID("ErrorMsg")), "bg", "gui")
  let s:ws_ctermfg = synIDattr(synIDtrans(hlID("ErrorMsg")), "bg", "cterm")
  let s:ws_guibg = synIDattr(synIDtrans(hlID("ErrorMsg")), "fg", "gui")
  let s:ws_ctermbg = synIDattr(synIDtrans(hlID("ErrorMsg")), "fg", "cterm")
end

" ------------------------------------------------------------------------------
" Vim Better Whitespace
" ------------------------------------------------------------------------------
exe "hi ExtraWhitespace gui=none cterm=none guifg=" . s:ws_guifg . " guibg=" . s:ws_guibg .
  \ " ctermfg=" . s:ws_ctermfg . " ctermbg=" . s:ws_ctermbg

nnoremap <silent> <F5> :StripWhitespace<CR> " Use F5 to remove all trailing spaces

" ------------------------------------------------------------------------------
" Airline
" ------------------------------------------------------------------------------
let g:airline_powerline_fonts = 1 " Our font supports powerline
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' " Shorten tab names to filenames
let g:airline#extensions#tabline#tab_nr_type = 1 " Show tab nunber instead of split number
let g:airline#extensions#wordcount#enabled = 0 " Disable wordcount extension

function! GetShortPath()
  return fnamemodify(expand("%"), ':~:.')
endfunction

function! GetWhitespaceSettings()
  return printf('%s:%s', &expandtab ? 'Spaces' : 'Tabs', &shiftwidth)
endfunction

function! AirlineInit()
  call airline#parts#define_function('shortpath', 'GetShortPath')
  call airline#parts#define_function('whitespacesettings', 'GetWhitespaceSettings')
  let g:airline_section_c = airline#section#create(['shortpath', ' ', 'readonly'])
  let g:airline_section_y = airline#section#create_right(['%<', 'ffenc', 'whitespacesettings'])
endfunction

augroup AirlineSettings
  " Enable whitespace checks for all files
  autocmd FileType * unlet! g:airline#extensions#whitespace#checks
  " Only use trailing whitespace check for the following file types
  autocmd FileType c,cpp,objc,objcpp let g:airline#extensions#whitespace#checks = ['trailing']
  " Add modifications to airline after init
  autocmd User AirlineAfterInit call AirlineInit()
augroup END

" ------------------------------------------------------------------------------
" NERDTree
" ------------------------------------------------------------------------------
let g:nerdtree_tabs_open_on_gui_startup = 0
let NERDTreeChDirMode = 2
let NERDTreeMinimalUI = 1
let NERDTreeMouseMode = 2
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1

map <unique> <Leader>n <Plug>NERDTreeTabsToggle<CR>
map <unique> <Leader>r <Plug>NERDTreeTabsFind<CR>

augroup NERDTreeSettings
  autocmd FileType nerdtree setlocal nolist " Hide whitespace symbols in nerdtree
augroup END

" ------------------------------------------------------------------------------
" Syntastic
" ------------------------------------------------------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_ballons = has('ballon_eval')
let g:syntastic_error_symbol = '☒'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_loc_list_height = 3
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = '-std=c++14 -stdlib=libc++'
let g:syntastic_cpp_checkers = ['clang_tidy']
let g:syntastic_cpp_clang_tidy_post_args = '-p build/compile_commands.json'

nnoremap <unique> <F4> :SyntasticCheck<CR>

" ------------------------------------------------------------------------------
" Ycm
" ------------------------------------------------------------------------------
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_config.py'
" let g:ycm_show_diagnostics_ui = 0 " Enable this line to have clang-tidy checks using syntastic

nnoremap <unique> jd :YcmCompleter GoToDefinition<CR>
nnoremap <unique> jj :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <unique> jc :YcmCompleter GoToDeclaration<CR>
nnoremap <unique> jk :YcmCompleter GoToInclude<CR>
nnoremap <unique> jp :YcmDiags<CR>
nnoremap <F3> :YcmForceCompileAndDiagnostics<CR>

" ------------------------------------------------------------------------------
" Fugitive
" ------------------------------------------------------------------------------
nnoremap <unique> <Space>gs :Gstatus<CR>
nnoremap <unique> <Space>gc :Gcommit -v -q<CR>
nnoremap <unique> <Space>gt :Gcommit -v -q %:p<CR>
nnoremap <unique> <Space>ga :Gcommit -v -q --amend<CR>
nnoremap <unique> <Space>gd :Gdiff<CR>
nnoremap <unique> <Space>ge :Gedit<CR>
nnoremap <unique> <Space>gr :Gread<CR>
nnoremap <unique> <Space>gw :Gwrite<CR><CR>
nnoremap <unique> <Space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <unique> <Space>gg :Ggrep<Space>
nnoremap <unique> <Space>gm :Gmove<Space>
nnoremap <unique> <Space>gp :Dispatch! git push<CR>
nnoremap <unique> <Space>gfr :Dispatch! git pull --rebase<CR>

" ------------------------------------------------------------------------------
" CtrP
" ------------------------------------------------------------------------------
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_by_filename = 1 " Search by filename as default
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = 'cd %s && pt -l --nocolor -g "" .'
let g:ctrlp_match_func = { 'match' : 'matcher#cmatch' }

nnoremap <unique> <C-o> :CtrlPBuffer<CR>

" ------------------------------------------------------------------------------
" Surround
" ------------------------------------------------------------------------------
" Replace substitute commands with surround
nmap s  ysi
nmap S  ysa
nmap s$ ys$
nmap sv gvs

" ------------------------------------------------------------------------------
" Incsearch
" ------------------------------------------------------------------------------
let g:incsearch#auto_nohlsearch = 1

map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

" ------------------------------------------------------------------------------
" Ack.vim
" ------------------------------------------------------------------------------
if executable('pt')
  let g:ackprg = 'pt --nocolor --nogroup --column --smart-case'
elseif executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
endif
let g:ackhighlight = 1
let g:ack_use_dispatch = 1

nnoremap <unique> <Leader>vv :Ack <cword><CR>
nnoremap <unique> <Leader>ff :Ack<Space>

" ------------------------------------------------------------------------------
" clang-format
" ------------------------------------------------------------------------------
let g:clang_format#detect_style_file = 1

augroup ClangFormatSettings
  autocmd FileType c,cpp,objc,objcpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc,objcpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
augroup END

" ------------------------------------------------------------------------------
" vim.cpp - enhanced c++ highlighting
" ------------------------------------------------------------------------------
let c_no_curly_error = 1 " Do not show curly braces error in cpp files
let g:cpp_class_scope_highlight = 1 " Highlight class scope
let g:cpp_experimental_template_highlight = 1 " Highlight template functions

" ------------------------------------------------------------------------------
" Local config
" ------------------------------------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
