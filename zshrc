#-------------------------------------------------------------------------------
# ZSH configuration
# by Markus Engelbrecht
#
# based on prezto (https://github.com/sorin-ionescu/prezto)
#
# MIT License
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# compile completion dump
#-------------------------------------------------------------------------------
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

#-------------------------------------------------------------------------------
# setup language
#-------------------------------------------------------------------------------
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#-------------------------------------------------------------------------------
# setup editors
#-------------------------------------------------------------------------------
if [[ "$OSTYPE" =~ "darwin" ]]; then
  export EDITOR='mate -w'
  export VISUAL='mate -w'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'

#-------------------------------------------------------------------------------
# setup temporary directory
#-------------------------------------------------------------------------------
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

#-------------------------------------------------------------------------------
# setup osx specifics
#-------------------------------------------------------------------------------
if [[ "$OSTYPE" =~ "darwin" ]]; then
  # Shortcut to use xcpretty and xcodebuild together
  xc() {
    xcodebuild "$@" | xcpretty -c
  }
fi

#-------------------------------------------------------------------------------
# setup linux specifics
#-------------------------------------------------------------------------------
if [[ "$OSTYPE" =~ "linux" ]]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

#-------------------------------------------------------------------------------
# setup cygwin specifics
#-------------------------------------------------------------------------------
if [[ "$OSTYPE" =~ "cygwin" ]]; then
  insecure_directories=(${(f@):-"$(compaudit 2>/dev/null)"})
  for directory in $insecure_directories; do
    chmod g-w $directory
  done
  if [[ "$insecure_directories" != "" ]]; then
    rm -f ~/.zcompdump
    compinit
  fi
fi

#-------------------------------------------------------------------------------
# helper functions
#-------------------------------------------------------------------------------
# Update and upgrade all packages, afterwards perform a cleanup
brewup() {
  brew update && brew upgrade --all && brew cleanup
}

# Set executable permissions to folders only
defMod() {
  find . -type d -exec chmod 755 {} +
  find . -type f -exec chmod 644 {} +
}

# Grep the history
greph() {
  history 0 | grep $1
}

#-------------------------------------------------------------------------------
# prezto configuration
#-------------------------------------------------------------------------------
zstyle ':prezto:*:*' case-sensitive 'no'
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:load' zfunction 'zmv'
zstyle ':prezto:module:editor' dot-expansion 'yes'
zstyle ':prezto:module:editor:info:completing' format ''
zstyle ':prezto:module:git:log:oneline' format '%C(auto,yellow)%h %C(auto,green)%ad%C(auto,red)%d %C(auto,reset)%s%C(auto,blue) [%cn]%C(auto,reset)'
zstyle ':prezto:module:syntax-highlighting' highlighters 'main' 'brackets' 'pattern' 'cursor' 'root'
zstyle ':prezto:module:syntax-highlighting' styles 'precommand' 'fg=green' 'path' 'fg=cyan' 'path_prefix' 'fg=cyan' 'path_approx' 'fg=yellow'

zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m: %~'
zstyle ':prezto:module:terminal:tab-title' format '%m: %~'

#-------------------------------------------------------------------------------
# source local zshrc file
#-------------------------------------------------------------------------------
if [[ -s "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

#-------------------------------------------------------------------------------
# zgen setup
#-------------------------------------------------------------------------------

#ZGEN_RESET_ON_CHANGE=($HOME/.zshrc ${HOME}/.zshrc.local)

source "$(readlink $HOME/.zgen/zgen.zsh)"

if ! zgen saved; then
  echo "creating zgen save"

  ln -sf ~/.zgen/sorin-ionescu/prezto-master ~/.zprezto

  zgen load sorin-ionescu/prezto
  zgen loadall <<EOPLUGINS
    sorin-ionescu/prezto modules/gnu-utility
    sorin-ionescu/prezto modules/helper
    sorin-ionescu/prezto modules/spectrum
    sorin-ionescu/prezto modules/editor
    sorin-ionescu/prezto modules/environment
    sorin-ionescu/prezto modules/terminal
    sorin-ionescu/prezto modules/history
    sorin-ionescu/prezto modules/directory
    sorin-ionescu/prezto modules/utility
    sorin-ionescu/prezto modules/git
    sorin-ionescu/prezto modules/completion
    sorin-ionescu/prezto modules/homebrew
    sorin-ionescu/prezto modules/python
    sorin-ionescu/prezto modules/osx
    sorin-ionescu/prezto modules/syntax-highlighting
    sorin-ionescu/prezto modules/history-substring-search
    mafredri/zsh-async
EOPLUGINS

  zgen load mgee/slimline

  zgen save
fi
