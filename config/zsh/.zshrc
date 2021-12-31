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

# MacPorts {{{
if [[ -d "/opt/local/bin" ]]; then
  export PATH="/opt/local/bin:/opt/local/sbin:${PATH}"
fi
# }}}

# Homebrew {{{
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

if [[ -d "${HOME}/.homebrew" ]]; then
  homebrew="${HOME}/.homebrew"
elif [[ -f "/usr/local/bin/brew" ]]; then
  homebrew="/usr/local"
fi

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

if (( $+commands[lsd] )); then
  alias ls="lsd --group-dirs first --icon never"
fi

# macOS Specifics {{{
if [[ "${OSTYPE}" =~ "darwin" ]]; then
  # Load ssh identities
  ssh-add -A -K 2> /dev/null

  export JAVA_HOME=$(/usr/libexec/java_home -v 11)
fi
# }}}

# tmux {{{
alias tmux="tmux -f '${XDG_CONFIG_HOME}/tmux/tmux.conf'"
alias tm='((tmux has -t default &> /dev/null) && tmux -u attach -t default) || tmux -u new -s default'
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

# Misc {{{
export GPG_TTY=$(tty)
# }}}

# Helper Functions {{{
# Set executable permissions to folders only
defMod() {
  find . -type d -exec chmod 755 {} +
  find . -type f -exec chmod 644 {} +
}

uuid4() {
  python -c 'import uuid; import sys; sys.stdout.write(str(uuid.uuid4()))' | pbcopy
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
# }}}

# Plugins {{{
# Bind UP and DOWN arrow keys
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

# Bind UP and DOWN arrow keys (compatibility fallback)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zstyle ':prezto:module:git:log:brief' format '%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
zstyle ':prezto:module:git:log:oneline' format '%C(auto,yellow)%h %C(auto,green)%ad%C(auto,red)%d %C(auto,reset)%s%C(auto,blue) [%cn]%C(auto,reset)'
zstyle ':prezto:module:git:log:medium' format '%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
if (( $+commands[lsd] )); then
  zstyle ':prezto:module:utility:ls' color 'no'
else
  zstyle ':prezto:module:utility:ls' dirs-first 'yes'
fi
zstyle ':prezto:*:*' color 'yes'

# Additional git aliases for Cleanup and Restore (X) {{{
alias gXc='git clean -dxf'
alias gXr='git reset --hard HEAD'
alias gXw='gXr && gXc'
# }}}

declare -A ZINIT
ZINIT[HOME_DIR]="${ZDATADIR}/zinit"
ZINIT[ZCOMPDUMP_PATH]="${ZCACHEDIR}/zcompdump"
ZINIT[COMPINIT_OPTS]="-u"
source "${ZDOTDIR}/zinit/zinit.zsh"

zinit light-mode compile"{*.zsh,lib/*.zsh,sections/*.zsh,zsh-async/*.zsh}" for mengelbrecht/slimline
zinit wait lucid for \
  PZTM::history \
  PZTM::utility \
  PZTM::git/alias.zsh

zinit wait"0" lucid light-mode for zsh-users/zsh-history-substring-search
zinit wait"1" lucid light-mode for \
  atinit"zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
  blockf atpull"zinit creinstall -q ." zsh-users/zsh-completions
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

# Local zshrc file {{{
if [[ -s "${ZDOTDIR}/config.local" ]]; then
  source "${ZDOTDIR}/config.local"
fi
# }}}

# Deduplicate entries in environment variables {{{
export -U PATH
export -U MANPATH
# }}}
