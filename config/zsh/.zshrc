#-------------------------------------------------------------------------------
# ZSH configuration
# by Markus Engelbrecht
#
# Based on Prezto by Sorin Ionescu (https://github.com/sorin-ionescu/prezto)
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Robby Russell <robby@planetargon.com>
#   James Cox <james@imaj.es>
#
# MIT License
#-------------------------------------------------------------------------------

# Language {{{
export LANG='en_US.UTF-8'
export LC_ALL=${LANG}
# }}}

# Temporary Directory {{{
if [[ ! -d "${TMPDIR}" ]]; then
  export TMPDIR="/tmp/${LOGNAME}"
  mkdir -p -m 700 "${TMPDIR}"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
# }}}

# Directories {{{
export DOTFILES="${HOME}/.dotfiles"
export PATH="${DOTFILES}/bin:${PATH}"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_RUNTIME_DIR="${TMPDIR}"

export ZPLUGINDIR="${ZDOTDIR}/plugins"
export ZDATADIR="${XDG_DATA_HOME}/zsh"
export ZCACHEDIR="${XDG_CACHE_HOME}/zsh"

if [[ ! -d "${XDG_DATA_HOME}" ]]; then
  mkdir -p "${XDG_DATA_HOME}"
fi

if [[ ! -d "${ZDATADIR}" ]]; then
  mkdir -p "${ZDATADIR}"
fi

if [[ ! -d "${ZCACHEDIR}" ]]; then
  mkdir -p "${ZCACHEDIR}"
fi
# }}}

# Homebrew {{{
export HOMEBREW_NO_ANALYTICS=1

homebrew="/usr/local"
if [[ -d "${homebrew}" ]]; then
  export PATH="${homebrew}/bin:${homebrew}/sbin:${PATH}"
  export MANPATH="${homebrew}/share/man:${MANPATH}"
  export INFOPATH="${homebrew}/share/info:${INFOPATH}"
  fpath=(${homebrew}/share/zsh/site-functions ${fpath})

  if [[ -d "${homebrew}/opt/coreutils" ]]; then
    export PATH="${homebrew}/opt/coreutils/libexec/gnubin:${PATH}"
    export MANPATH="${homebrew}/opt/coreutils/libexec/gnuman:${MANPATH}"
  fi

  brewup() {
    brew update && brew upgrade && brew cleanup
  }
fi

alias cask='brew cask'
# }}}

# MacPorts {{{
macports="/opt/local"
if [[ -d "${macports}" ]]; then
  export PATH="${macports}/bin:${macports}/sbin:${PATH}"
  export MANPATH="${macports}/share/man:${MANPATH}"
  export INFOPATH="${macports}/share/info:${INFOPATH}"
  fpath=(${macports}/share/zsh/site-functions ${fpath})

  if [[ -d "${macports}/libexec/gnubin" ]]; then
    export PATH="${macports}/libexec/gnubin:${PATH}"
  fi

  portup() {
    sudo port selfupdate && sudo port upgrade outdated && sudo port reclaim
  }
fi
# }}}

# Editors {{{
if (( $+commands[nvim] )); then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
# Disable less search history
export LESSHISTFILE=-
# }}}

# macOS Specifics {{{
if [[ "${OSTYPE}" =~ "darwin" ]]; then
  # Load ssh identities
  ssh-add -A -K 2> /dev/null

  export JAVA_HOME=$(/usr/libexec/java_home -v 14)

  alias o='open'
fi
# }}}

# tmux {{{
alias tmux="tmux -f '${XDG_CONFIG_HOME}/tmux/tmux.conf'"
export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"
# }}}

# npm {{{
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/config"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_TMP="${XDG_RUNTIME_DIR}/npm"
# }}}

# Directory {{{
setopt AUTO_CD           # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD        # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME     # Push to home directory when no argument is given.
setopt AUTO_NAME_DIRS    # Auto add variable-stored paths to ~ list.
setopt MULTIOS           # Write to multiple descriptors.
setopt EXTENDED_GLOB     # Use extended globbing syntax.
unsetopt CLOBBER         # Do not overwrite existing files with > and >>. Use >! and >>! to bypass.
# }}}

# Window Title {{{
set_window_title_to_cwd() {
  print -Pn "\e]0;%~\a"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_window_title_to_cwd
# }}}

# Key Bindings {{{

# Expands .... to ../..
function expand-dot-to-parent-directory-path {
  if [[ ${LBUFFER} = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path

bindkey "." expand-dot-to-parent-directory-path
bindkey "^[[3~" delete-char # bind delete key to delete character

# Use shift+tab to navigate backwards
bindkey '^[[Z' reverse-menu-complete

# Bindings for other terminals
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

# Bindings for Terminal
bindkey "^[f" forward-word
bindkey "^[b" backward-word
# }}}

# Aliases {{{

# ls {{{
if (( $+commands[dircolors] )); then
  eval "$(dircolors --sh)" # exports LS_COLORS
  alias ls='ls --group-directories-first --color=auto'
else
  export LSCOLORS='exfxcxdxbxGxDxabagacad'
  # Define colors for the completion system.
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
  alias ls='ls -G'
fi

alias l='ls'
alias ll='ls -lh'
alias la='ll -A'
# }}}

# htop {{{

if (( $+commands[htop] )); then
  alias top=htop
fi

# }}}

# Grep {{{
export GREP_COLOR='37;45'             # BSD
export GREP_COLORS="mt=${GREP_COLOR}" # GNU
alias grep="grep --color=auto"
# }}}

# Git {{{
_git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
_git_log_oneline_format='%C(auto,yellow)%h %C(auto,green)%ad%C(auto,red)%d %C(auto,reset)%s%C(auto,blue) [%cn]%C(auto,reset)'
_git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

alias g='git'

# Branch (b) {{{
alias gb='git branch'
alias gbc='git checkout -b'
alias gbl='git branch -v'
alias gbL='git branch -av'
alias gbx='git branch -d'
alias gbX='git branch -D'
alias gbm='git branch -m'
alias gbM='git branch -M'
alias gbs='git show-branch'
alias gbS='git show-branch -a'
# }}}

# Commit (c) {{{
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcO='git checkout --patch'
alias gcf='git commit --amend --reuse-message HEAD'
alias gcF='git commit --verbose --amend'
alias gcp='git cherry-pick --ff'
alias gcP='git cherry-pick --no-commit'
alias gcr='git revert'
alias gcR='git reset "HEAD^"'
alias gcs='git show'
# }}}

# Conflict (C) {{{
alias gCl='git status | sed -n "s/^.*both [a-z]*ed: *//p"'
alias gCa='git add $(gCl)'
alias gCe='git mergetool $(gCl)'
alias gCo='git checkout --ours --'
alias gCO='gCo $(gCl)'
alias gCt='git checkout --theirs --'
alias gCT='gCt $(gCl)'
# }}}

# Data (d) {{{
alias gd='git ls-files'
alias gdc='git ls-files --cached'
alias gdx='git ls-files --deleted'
alias gdm='git ls-files --modified'
alias gdu='git ls-files --other --exclude-standard'
alias gdk='git ls-files --killed'
alias gdi='git status --porcelain --short --ignored | sed -n "s/^!! //p"'
# }}}

# Fetch (f) {{{
alias gf='git fetch'
alias gfc='git clone'
alias gfm='git pull'
alias gfr='git pull --rebase'
# }}}

# Grep (g) {{{
alias gg='git grep'
alias ggi='git grep --ignore-case'
alias ggl='git grep --files-with-matches'
alias ggL='git grep --files-without-match'
alias ggv='git grep --invert-match'
alias ggw='git grep --word-regexp'
# }}}

# Index (i) {{{
alias gia='git add'
alias giA='git add --patch'
alias giu='git add --update'
alias gid='git diff --no-ext-diff --cached'
alias giD='git diff --no-ext-diff --cached --word-diff'
alias gir='git reset'
alias giR='git reset --patch'
alias gix='git rm -r --cached'
alias giX='git rm -rf --cached'
# }}}

# Log (l) {{{
alias gl='git log --topo-order --pretty=format:"${_git_log_medium_format}"'
alias gls='git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'
alias gld='git log --topo-order --stat --patch --full-diff --pretty=format:"${_git_log_medium_format}"'
alias glo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"'
alias glb='git log --topo-order --pretty=format:"${_git_log_brief_format}"'
alias glc='git shortlog --summary --numbered'
# }}}

# Merge (m) {{{
alias gm='git merge'
alias gmC='git merge --no-commit'
alias gmF='git merge --no-ff'
alias gma='git merge --abort'
alias gmt='git mergetool'
# }}}

# Push (p) {{{
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpa='git push --all'
alias gpA='git push --all && git push --tags'
alias gpt='git push --tags'
alias gpc='git push --set-upstream origin "$(git symbolic-ref HEAD 2> /dev/null)"'
alias gpp='git pull origin "$(git-branch-current 2> /dev/null)" && git push origin "$(git-branch-current 2> /dev/null)"'
# }}}

# Rebase (r) {{{
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias grs='git rebase --skip'
# }}}

# Remote (R) {{{
alias gR='git remote'
alias gRl='git remote --verbose'
alias gRa='git remote add'
alias gRx='git remote rm'
alias gRm='git remote rename'
alias gRu='git remote update'
alias gRp='git remote prune'
alias gRs='git remote show'
# }}}

# Stash (s) {{{
alias gs='git stash'
alias gsa='git stash apply'
alias gsx='git stash drop'
alias gsl='git stash list'
alias gsd='git stash show --patch --stat'
alias gsp='git stash pop'
alias gss='git stash save --include-untracked'
alias gsS='git stash save --patch --no-keep-index'
alias gsw='git stash save --include-untracked --keep-index'
# }}}

# Submodule (S) {{{
alias gS='git submodule'
alias gSa='git submodule add'
alias gSf='git submodule foreach'
alias gSi='git submodule init'
alias gSI='git submodule update --init --recursive'
alias gSl='git submodule status'
alias gSs='git submodule sync'
alias gSu='git submodule foreach git pull origin master'
# }}}

# Working Copy (w) {{{
alias gws='git status --short'
alias gwS='git status'
alias gwd='git diff --no-ext-diff'
alias gwD='git diff --no-ext-diff --word-diff'
alias gwr='git reset --soft'
alias gwR='git reset --hard'
alias gwc='git clean -n'
alias gwC='git clean -f'
alias gwx='git rm -r'
alias gwX='git rm -rf'
# }}}

# git-svn (v) {{{
alias gvc='git svn clone'
alias gvp='git svn dcommit'
alias gvf='git svn fetch'
alias gvi='git svn init'
alias gvr='git svn rebase'
# }}}

# Cleanup and Restore (X) {{{
alias gXc='git clean -dxf'
alias gXr='git reset --hard HEAD'
alias gXw='gXr && gXc'
# }}}

# }}}

# Misc {{{
export GPG_TTY=$(tty)

alias rm='nocorrect rm -i'
alias tm='((tmux has -t default &> /dev/null) && tmux -u attach -t default) || tmux -u new -s default'
# }}}
# }}}

# Helper Functions {{{
diff() {
  if (( $+commands[git] )); then
    git --no-pager diff --color=auto --no-ext-diff --no-index "$@"
  else
    command diff --unified "$@"
  fi
}

# Set executable permissions to folders only
defMod() {
  find . -type d -exec chmod 755 {} +
  find . -type f -exec chmod 644 {} +
}

# Grep the history
greph() {
  history 0 | grep "${@}"
}

# Fetch gitignore settings
gi() {
  curl -L -s "https://www.gitignore.io/api/${@}"
}

mkcd() {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

cdls() {
  builtin cd "$argv[-1]" && ls -l "${(@)argv[1,-2]}"
}

uuid4() {
  python -c 'import uuid; import sys; sys.stdout.write(str(uuid.uuid4()))' | pbcopy
}

# fh - "find [in] history"
# From: https://github.com/junegunn/fzf/wiki/examples#command-history
function fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

fshow() {
  local commit
  commit=$(git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | fzf --ansi --no-sort --reverse --tiebreak=index --extended | awk '{print $1}')
  if [[ -n ${commit} ]]; then
    echo ${commit} | pbcopy
    git show ${commit}
  fi
}

shrinkPDF() {
  ps2pdf "${1}" "${1}.pdf"
  mv "${1}.pdf" "${1}"
}
# }}}

# Completion System {{{

# Options {{{
setopt CORRECT          # correct command names
setopt ALWAYS_TO_END    # cursor moves to end of completion
setopt AUTO_LIST        # list choices
setopt AUTO_MENU        # automatically use menu
setopt AUTO_PARAM_SLASH # if completion is directory add trailing slash
setopt COMPLETE_IN_WORD # also complete in word
setopt PATH_DIRS        # path search even on command names with slashes
unsetopt CASE_GLOB      # globbing case insensitively
unsetopt MENU_COMPLETE  # always display menu, don't directly insert
# }}}

# Style {{{
# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZCACHEDIR}/zcompcache"

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Z}{a-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# }}}

# }}}

# History {{{
HISTFILE="${XDG_DATA_HOME}/zsh/history"

HISTSIZE=10000 # max entries
SAVEHIST=10000

setopt BANG_HIST
setopt EXTENDED_HISTORY     # save timestamp and duration
setopt INC_APPEND_HISTORY   # append entries directly
setopt SHARE_HISTORY        # share across sessions
setopt HIST_IGNORE_DUPS     # ignore duplicates
setopt HIST_IGNORE_ALL_DUPS # new entries replace old ones
setopt HIST_IGNORE_SPACE    # trim entries
setopt HIST_SAVE_NO_DUPS    # dont save duplicates
setopt HIST_VERIFY          # verify history entry before executing
# }}}

# Plugins {{{

# Completions {{{
source "${ZPLUGINDIR}/zsh-completions/zsh-completions.plugin.zsh"

# Cache {{{
local zcompdump="${ZCACHEDIR}/zcompdump"

autoload -Uz compinit && compinit -C -d "${zcompdump}"

{
  # Compile the completion dump to increase startup speed.
  if [[ -s "${zcompdump}" && (! -s "${zcompdump}.zwc" || "${zcompdump}" -nt "${zcompdump}.zwc") ]]; then
    zcompile "${zcompdump}"
  fi
} &!
# }}}
# }}}

# History Substring Search {{{
source "${ZPLUGINDIR}/zsh-history-substring-search/zsh-history-substring-search.zsh"

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

# Bind UP and DOWN arrow keys
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

# Bind UP and DOWN arrow keys (compatibility fallback)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# }}}

# Syntax Highlighting {{{
source "${ZPLUGINDIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=yellow'
# }}}

# Autosuggestions {{{
source "${ZPLUGINDIR}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
ZSH_AUTOSUGGEST_USE_ASYNC=1
# }}}

# fzf {{{
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS="--reverse --cycle --inline-info --select-1 --exit-0 --multi --color=16"
  export FZF_COMPLETION_TRIGGER='\\'
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git" --glob "!.svn" --glob "!Applications/" --glob "!Library/"'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

  if [[ -e "/usr/local/opt/fzf" ]]; then
    source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
    source "/usr/local/opt/fzf/shell/key-bindings.zsh"
  fi
fi
# }}}

# Slimline {{{
export GITLINE_REPO_INDICATOR='|'
source "${ZPLUGINDIR}/slimline/slimline.plugin.zsh"
# }}}

# }}}

# Local zshrc file {{{
if [[ -s "${ZDOTDIR}/config.local" ]]; then
  source "${ZDOTDIR}/config.local"
fi
# }}}

# Deduplicate entries in environment variables {{{
export -U PATH
export -U MANPATH
# }}}
