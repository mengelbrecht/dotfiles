if test -d "$HOME/.homebrew"
  set homebrew "$HOME/.homebrew"
else if -f "/usr/local/bin/brew"
  set homebrew "/usr/local"
end

if test -d $homebrew
    fish_add_path "$homebrew/bin"

    if test -d "$homebrew/opt/coreutils/libexec/gnubin"
        fish_add_path "$homebrew/opt/coreutils/libexec/gnubin"
    end

    set -gx HOMEBREW_NO_ANALYTICS "1"
    set -gx HOMEBREW_NO_ENV_HINTS "1"

    alias brewup "brew update && brew upgrade && brew cleanup"
end
