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

" Theme {{{
syntax on

"" MIT License
""
"" Copyright (c) 2021 Catppuccin
""
"" Permission is hereby granted, free of charge, to any person obtaining a copy
"" of this software and associated documentation files (the "Software"), to deal
"" in the Software without restriction, including without limitation the rights
"" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"" copies of the Software, and to permit persons to whom the Software is
"" furnished to do so, subject to the following conditions:
""
"" The above copyright notice and this permission notice shall be included in all
"" copies or substantial portions of the Software.
""
"" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
"" SOFTWARE.

" Name: catppuccin_macchiato.vim

set background=dark
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='catppuccin_macchiato'
set t_Co=256

let s:rosewater = "#F4DBD6"
let s:flamingo = "#F0C6C6"
let s:pink = "#F5BDE6"
let s:mauve = "#C6A0F6"
let s:red = "#ED8796"
let s:maroon = "#EE99A0"
let s:peach = "#F5A97F"
let s:yellow = "#EED49F"
let s:green = "#A6DA95"
let s:teal = "#8BD5CA"
let s:sky = "#91D7E3"
let s:sapphire = "#7DC4E4"
let s:blue = "#8AADF4"
let s:lavender = "#B7BDF8"

let s:text = "#CAD3F5"
let s:subtext1 = "#B8C0E0"
let s:subtext0 = "#A5ADCB"
let s:overlay2 = "#939AB7"
let s:overlay1 = "#8087A2"
let s:overlay0 = "#6E738D"
let s:surface2 = "#5B6078"
let s:surface1 = "#494D64"
let s:surface0 = "#363A4F"

let s:base = "#24273A"
let s:mantle = "#1E2030"
let s:crust = "#181926"

function! s:hi(group, guisp, guifg, guibg, gui, cterm)
  let cmd = ""
  if a:guisp != ""
    let cmd = cmd . " guisp=" . a:guisp
  endif
  if a:guifg != ""
    let cmd = cmd . " guifg=" . a:guifg
  endif
  if a:guibg != ""
    let cmd = cmd . " guibg=" . a:guibg
  endif
  if a:gui != ""
    let cmd = cmd . " gui=" . a:gui
  endif
  if a:cterm != ""
    let cmd = cmd . " cterm=" . a:cterm
  endif
  if cmd != ""
    exec "hi " . a:group . cmd
  endif
endfunction

call s:hi("Normal", "NONE", s:text, s:base, "NONE", "NONE")
call s:hi("Visual", "NONE", "NONE", s:surface1,"bold", "bold")
call s:hi("Conceal", "NONE", s:overlay1, "NONE", "NONE", "NONE")
call s:hi("ColorColumn", "NONE", "NONE", s:surface0, "NONE", "NONE")
call s:hi("Cursor", "NONE", s:base, s:text, "NONE", "NONE")
call s:hi("lCursor", "NONE", s:base, s:text, "NONE", "NONE")
call s:hi("CursorIM", "NONE", s:base, s:text, "NONE", "NONE")
call s:hi("CursorColumn", "NONE", "NONE", s:mantle, "NONE", "NONE")
call s:hi("CursorLine", "NONE", "NONE", s:surface0, "NONE", "NONE")
call s:hi("Directory", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("DiffAdd", "NONE", s:base, s:green, "NONE", "NONE")
call s:hi("DiffChange", "NONE", s:base, s:yellow, "NONE", "NONE")
call s:hi("DiffDelete", "NONE", s:base, s:red, "NONE", "NONE")
call s:hi("DiffText", "NONE", s:base, s:blue, "NONE", "NONE")
call s:hi("EndOfBuffer", "NONE", "NONE", "NONE", "NONE", "NONE")
call s:hi("ErrorMsg", "NONE", s:red, "NONE", "bolditalic"    , "bold,italic")
call s:hi("VertSplit", "NONE", s:crust, "NONE", "NONE", "NONE")
call s:hi("Folded", "NONE", s:blue, s:surface1, "NONE", "NONE")
call s:hi("FoldColumn", "NONE", s:overlay0, s:base, "NONE", "NONE")
call s:hi("SignColumn", "NONE", s:surface1, s:base, "NONE", "NONE")
call s:hi("IncSearch", "NONE", s:surface1, s:pink, "NONE", "NONE")
call s:hi("CursorLineNR", "NONE", s:lavender, "NONE", "NONE", "NONE")
call s:hi("LineNr", "NONE", s:surface1, "NONE", "NONE", "NONE")
call s:hi("MatchParen", "NONE", s:peach, "NONE", "bold", "bold")
call s:hi("ModeMsg", "NONE", s:text, "NONE", "bold", "bold")
call s:hi("MoreMsg", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("NonText", "NONE", s:overlay0, "NONE", "NONE", "NONE")
call s:hi("Pmenu", "NONE", s:overlay2, s:surface0, "NONE", "NONE")
call s:hi("PmenuSel", "NONE", s:text, s:surface1, "bold", "bold")
call s:hi("PmenuSbar", "NONE", "NONE", s:surface1, "NONE", "NONE")
call s:hi("PmenuThumb", "NONE", "NONE", s:overlay0, "NONE", "NONE")
call s:hi("Question", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("QuickFixLine", "NONE", "NONE", s:surface1, "bold", "bold")
call s:hi("Search", "NONE", s:pink, s:surface1, "bold", "bold")
call s:hi("SpecialKey", "NONE", s:subtext0, "NONE", "NONE", "NONE")
call s:hi("SpellBad", "NONE", s:base, s:red, "NONE", "NONE")
call s:hi("SpellCap", "NONE", s:base, s:yellow, "NONE", "NONE")
call s:hi("SpellLocal", "NONE", s:base, s:blue, "NONE", "NONE")
call s:hi("SpellRare", "NONE", s:base, s:green, "NONE", "NONE")
call s:hi("StatusLine", "NONE", s:text, s:mantle, "NONE", "NONE")
call s:hi("StatusLineNC", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("StatusLineTerm", "NONE", s:text, s:mantle, "NONE", "NONE")
call s:hi("StatusLineTermNC", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("TabLine", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("TabLineFill", "NONE", "NONE", s:mantle, "NONE", "NONE")
call s:hi("TabLineSel", "NONE", s:green, s:surface1, "NONE", "NONE")
call s:hi("Title", "NONE", s:blue, "NONE", "bold", "bold")
call s:hi("VisualNOS", "NONE", "NONE", s:surface1, "bold", "bold")
call s:hi("WarningMsg", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("WildMenu", "NONE", "NONE", s:overlay0, "NONE", "NONE")
call s:hi("Comment", "NONE", s:overlay0, "NONE", "NONE", "NONE")
call s:hi("Constant", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Identifier", "NONE", s:flamingo, "NONE", "NONE", "NONE")
call s:hi("Statement", "NONE", s:mauve, "NONE", "NONE", "NONE")
call s:hi("PreProc", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Type", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Special", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Underlined", "NONE", s:text, s:base, "underline", "underline")
call s:hi("Error", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Todo", "NONE", s:base, s:flamingo, "bold", "bold")

call s:hi("String", "NONE", s:green, "NONE", "NONE", "NONE")
call s:hi("Character", "NONE", s:teal, "NONE", "NONE", "NONE")
call s:hi("Number", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Boolean", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Float", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Function", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Conditional", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Repeat", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Label", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Operator", "NONE", s:sky, "NONE", "NONE", "NONE")
call s:hi("Keyword", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Include", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("StorageClass", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Structure", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Typedef", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("debugPC", "NONE", "NONE", s:crust, "NONE", "NONE")
call s:hi("debugBreakpoint", "NONE", s:overlay0, s:base, "NONE", "NONE")

hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link SpecialChar Special
hi link Tag Special
hi link Delimiter Special
hi link SpecialComment Special
hi link Debug Special
hi link Exception Error
hi link StatusLineTerm StatusLine
hi link StatusLineTermNC StatusLineNC
hi link Terminal Normal
hi link Ignore Comment

" Set terminal colors for playing well with plugins like fzf
let g:terminal_ansi_colors = [
  \ s:surface1, s:red, s:green, s:yellow, s:blue, s:pink, s:teal, s:subtext1,
  \ s:surface2, s:red, s:green, s:yellow, s:blue, s:pink, s:teal, s:subtext0
\ ]
" }}}

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

set statusline=%{&ff}%y\ %<%F%m%=%l/%L

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
