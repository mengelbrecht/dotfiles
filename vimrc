" ------------------------------------------------------------------------------
" vimrc
"
" Based on https://github.com/Soliah/dotfiles/blob/master/vimrc
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" Basic Settings
" ------------------------------------------------------------------------------
runtime bundle/vim-pathogen/autoload/pathogen.vim " Load Pathogen

command! W :w " Map W to w.
command! Wq :wq " Map Wq to wq.
set nocompatible " Turn off vi compatibility.

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

set notimeout " Fix lag in iTerm.
set ttimeout
set timeoutlen=50
set nomodeline
set autochdir " Automatically change to directory of current file.
set wildchar=<Tab> wildmenu wildmode=full
let mapleader = "," " Use comma as leader.

" ------------------------------------------------------------------------------
" Pathogen
" ------------------------------------------------------------------------------
execute pathogen#infect()

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
set listchars=tab:▸·,trail:· " Show leading whitespace
set list

" Bind F5 to remove trailing whitespace.
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR> " Use F5 to remove all trailing spaces

" ------------------------------------------------------------------------------
" Buffer Handling
" ------------------------------------------------------------------------------

function! SwitchToNextBuffer(incr)
  let current = bufnr("%")
  let last = bufnr("$")
  let new = current + a:incr
  while 1
    let buftype = getbufvar(new, "&filetype")
    if new != 0 && bufexists(new) && buftype != '' && buftype != 'netrw'
      execute ":buffer ".new
      break
    else
      let new = new + a:incr
      if new < 1
        let new = last
      elseif new > last
        let new = 1
      endif
      if new == current
        break
      endif
    endif
  endwhile
endfunction

" Bind Tab and Shift-Tab to buffer switching.
nnoremap <silent> <TAB> :call SwitchToNextBuffer(1)<CR>
nnoremap <silent> <S-TAB> :call SwitchToNextBuffer(-1)<CR>

" Close buffer without closing the window.
nmap <leader>d :Bdelete<CR>

" ------------------------------------------------------------------------------
" Window Handling
" ------------------------------------------------------------------------------
" Switch windows using Control-Tab and Control-Shift-Tab.
noremap <silent> <C-TAB> <C-W>w
noremap <silent> <C-S-TAB> <C-W>W

" Resize window using + and -.
nnoremap <silent> + :exe "vertical resize " . (winwidth(0) * 23/20)<CR>
nnoremap <silent> - :exe "vertical resize " . (winwidth(0) * 20/23)<CR>

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
syntax on " Enable syntax highlighting.
filetype on " Detect file type.
filetype indent on " Enable file indenting.
filetype plugin indent on " Load syntax files for better indenting.

" ------------------------------------------------------------------------------
" User Interface
" ------------------------------------------------------------------------------
set background=dark
colorscheme Tomorrow-Night

if has('gui_running')
    set guioptions-=m " Disable menu bar.
    set guioptions-=T " Disable the tool bar bar.
    set guioptions-=a " Do not auto copy selection to clipboard.

    set guifont=Source\ Code\ Pro\ for\ Powerline:h13
    set vb " Disable the audible bell.
endif

if has('mouse')
    set mouse=a " Enable mouse everywhere.
    set mousemodel=popup_setpos " Show a pop-up for right-click.
    set mousehide " Hide mouse while typing.
endif

" ------------------------------------------------------------------------------
" Colors
" ------------------------------------------------------------------------------
let guiBg = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
let ctermBg = synIDattr(synIDtrans(hlID("Normal")), "bg", "cterm")
let identifierGuiFg = synIDattr(synIDtrans(hlID("Identifier")), "fg", "gui")
let identifierCtermFg = synIDattr(synIDtrans(hlID("Identifier")), "fg", "cterm")
let stringGuiFg = synIDattr(synIDtrans(hlID("String")), "fg", "gui")
let stringCtermFg = synIDattr(synIDtrans(hlID("String")), "fg", "cterm")
let constantGuiFg = synIDattr(synIDtrans(hlID("Constant")), "fg", "gui")
let constantCtermFg = synIDattr(synIDtrans(hlID("Constant")), "fg", "cterm")
let preprocGuiFg = synIDattr(synIDtrans(hlID("PreProc")), "fg", "gui")
let preprocCtermFg = synIDattr(synIDtrans(hlID("PreProc")), "fg", "cterm")

" ------------------------------------------------------------------------------
" Line highlighting
" ------------------------------------------------------------------------------
set cursorline nocursorcolumn

" Bind F6 to toggle long line highlighting.
exe "hi LongLine guibg=" . identifierGuiFg . " guifg=" . guiBg . " ctermbg=" . identifierCtermFg . " ctermfg=" . ctermBg
nnoremap <silent> <F6>
      \ :if exists('w:long_line_match') <Bar>
      \   silent! call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('LongLine', '\%>100v.\+', -1) <Bar>
      \ endif<CR>

" ------------------------------------------------------------------------------
" Status Line
" ------------------------------------------------------------------------------
" Always show status.
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
set laststatus=2

" Disable status line fill chars.
set fillchars+=stl:\ ,stlnc:\ " Space.

" ------------------------------------------------------------------------------
" Netrw
" ------------------------------------------------------------------------------
let g:netrw_altv = 1
let g:netrw_browse_split = 4
let g:netrw_preview = 1
let g:netrw_liststyle = 3
let g:netrw_winsize = 80

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
      vertical resize 20
  endif
endfunction

map <silent> <C-E> :call ToggleVExplorer()<CR>

" ------------------------------------------------------------------------------
" Git Gutter
" ------------------------------------------------------------------------------
" Adjust colors.
exe "hi GitGutterAdd guifg=" . stringGuiFg . " ctermfg=" . stringCtermFg
exe "hi GitGutterChange guifg=" . constantGuiFg . " ctermfg=" . constantCtermFg
exe "hi GitGutterDelete guifg=" . identifierGuiFg . " ctermfg=" . identifierCtermFg
exe "hi GitGutterChangeDelete guifg=" . preprocGuiFg . " ctermfg=" . preprocCtermFg

" Jump to hunks.
nmap gh <Plug>GitGutterNextHunk
nmap gH <Plug>GitGutterPrevHunk

" ------------------------------------------------------------------------------
" Local Config
" ------------------------------------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

